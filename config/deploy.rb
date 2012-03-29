$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

set :branch, $1 if `git branch` =~ /\* (\S+)\s/m

set :rvm_ruby_string, 'ruby-1.9.2-p180@maasiveweb'

set :keep_releases, 5

default_run_options[:pty] = true

## Multistage support
set :stages, %w(staging production)
set :default_stage, "staging"

## MaaSive Web App!
set :application, "MaaSiveWeb"

set :user,        "deploy"
set :group,       "users"
set :use_sudo,    false

set :scm, :git
set :repository,  "git@github.com:elc/maasive-web.git"

set :app_parent_path, "/srv/www/"
set :app_dir_name, "staging.#{application}"
set :deploy_env, "staging"
set :deploy_to, "#{app_parent_path}#{app_dir_name}"
set :deploy_via,  :remote_cache

set :rails_env, :production

set :unicorn_binary, "/usr/local/rvm/gems/ruby-1.9.2-p180@maasiveweb/bin/unicorn"
set :unicorn_config, "#{current_path}/config/unicorn/#{rails_env}.rb"
set :unicorn_pid,    "#{shared_path}/pids/unicorn.pid"

before "deploy:start", "custom:setup_rvm_ruby"

after "deploy:setup", "custom:install_bundler"
after "deploy:setup", "custom:create_pids_directory"

before "deploy:restart", "db:migrate"

def remote_file_exists?(full_path)
  'true' ==  capture("if [ -e #{full_path} ]; then echo 'true'; fi").strip
end

namespace :custom do
  task :install_bundler, :roles => :app do
    run "rvm use 1.9.2-p180@maasiveweb --create"
    run "gem install bundler --no-rdoc --no-ri"
  end
  
  task :create_pids_directory, :roles => :app do
    run "mkdir -p #{shared_path}/pids"
  end

  task :setup_rvm_ruby do
    disable_rvm_shell do
      run "rvm install ruby-1.9.2-p180"
      run "rvm use ruby-1.9.2-p180@maasiveweb --create"
    end
  end
end

namespace :elc do
  task :knock do
    servers = []
    roles.each do |r|
      servers << r[1].servers
    end
    servers.flatten!.uniq!
    servers.each do |s|
      puts("telnet #{s} 12345")
    end
    servers.each do |s|
      exec("telnet #{s} 12345 2>&1 > /dev/null &")
    end
  end
end

namespace :db do

  task :migrate, :roles => :app, :only => {:primary => true} do
    run "cd #{current_path} && RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
  end

end

namespace :tail do

  task :logs, :roles => :app do
    run "tail -f #{shared_path}/log/#{rails_env}.log"
  end
  
  task :unicorn_err, :roles => :app do
    run "tail -f #{shared_path}/log/unicorn.stderr.log"
  end
  
  task :unicorn_out, :roles => :app do
    run "tail -f #{shared_path}/log/unicorn.stdout.log"
  end

end

namespace :deploy do
  task :writable_proxy_sock do
    run "chmod 777 #{app_parent_path}#{app_dir_name}/proxy.sock"
  end
  task :start, :roles => :app, :except => { :no_release => true } do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  task :stop, :roles => :app, :except => { :no_release => true } do
    if remote_file_exists? unicorn_pid
      run "kill `cat #{unicorn_pid}`"
    end
  end
  task :graceful_stop, :roles => :app, :except => { :no_release => true } do
    run "kill -s QUIT `cat #{unicorn_pid}`"
  end
  task :reload, :roles => :app, :except => { :no_release => true } do
    run "kill -s USR2 `cat #{unicorn_pid}`"
  end
  task :restart, :roles => :app, :except => { :no_release => true } do
    stop
    start
  end
end