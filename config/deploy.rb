require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

set :branch, $1 if `git branch` =~ /\* (\S+)\s/m
set :rvm_type, :system
set :rvm_ruby_string, 'ruby-1.9.2-p180@maasiveweb'
set :keep_releases, 5

default_run_options[:pty] = true

set :stages, %w(staging production)
set :default_stage, "staging"

## MaaSive Web App!
set :application, "MaaSiveWeb"

set :user,        "deploy"
set :group,       "users"
set :use_sudo,    false

set :scm, :git
set :repository,  "git@github.com:elc/maasive-web.git"

set :deploy_env, "staging"
set :app_parent_path, "/srv/www/"
set :app_dir_name, "#{deploy_env}.#{application}"
set :deploy_to, "#{app_parent_path}#{app_dir_name}"
set :deploy_via,  :remote_cache

set :rails_env, "#{deploy_env}"

set :unicorn_binary, "unicorn"
set :unicorn_pid,    "#{shared_path}/pids/#{unicorn_binary}.pid"

# Callbacks
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
before "deploy:restart", "db:migrate"

after "deploy:setup", "deploy:install_bundler"
after "deploy:setup", "deploy:create_pids_directory"
after "deploy", "rvm:trust_rvmrc"

# Helper functions
def remote_process_running?(pid)
  'true' == capture("if [ -e #{pid} ]; then if [ -d /proc/`cat #{pid}` ]; then echo 'true'; fi; fi").strip
end

def kill_remote_process!(pid, extra_params=false)
  if remote_process_running? pid
    command = "kill "
    command << extra_params if extra_params
    command << " `cat #{pid}`"
    run command
  else
    logger.important("Couldn't kill Process because is not running.", "Process")
  end
end

# Tasks

## Deploy
namespace :deploy do
  
  task :writable_proxy_sock do
    run "chmod 777 #{app_parent_path}#{app_dir_name}/proxy.sock"
  end
  
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  
  task :stop, :roles => :app, :except => { :no_release => true } do
    kill_remote_process! unicorn_pid
  end
  
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    kill_remote_process! unicorn_pid, '-s QUIT' 
  end
  
  task :reload, :roles => :app, :except => { :no_release => true } do
    kill_remote_process! unicorn_pid, '-s USR2'
  end
  
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
  
  task :install_bundler, :roles => :app do
    run "rvm use #{rvm_ruby_string} --create"
    run "gem install bundler --no-rdoc --no-ri"
  end
  
  task :create_pids_directory, :roles => :app do
    run "mkdir -p #{shared_path}/pids"
  end
  
end

## DB
namespace :db do

  task :migrate, :roles => :app, :only => {:primary => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end

end

## Tail
namespace :tail do

  task :logs, :roles => :app do
    run "tail -f #{shared_path}/log/#{rails_env}.log"
  end
  
  task :unicorn_err, :roles => :app do
    run "tail -f #{shared_path}/log/#{unicorn_binary}.stderr.log"
  end
  
  task :unicorn_out, :roles => :app do
    run "tail -f #{shared_path}/log/#{unicorn_binary}.stdout.log"
  end

end

## RVM
namespace :rvm do
  
  task :trust_rvmrc do
    run "rvm rvmrc trust #{release_path}"
  end
  
end