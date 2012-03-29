require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

server 'maas-web01.elctech.net', :app, :web, :primary => true
server 'maas-web02.elctech.net', :app, :web
#server 'maas-web03.elctech.net', :app, :web
#server 'maas-web04.elctech.net', :app, :web

set :deploy_env,  "production"
set :app_dir_name, "#{application}"
set :deploy_to, "#{app_parent_path}#{app_dir_name}"
set :rails_env,   "#{deploy_env}"

set :unicorn_binary, "unicorn"
set :unicorn_config, "#{current_path}/config/unicorn/#{rails_env}.rb"
set :unicorn_pid,    "#{shared_path}/pids/unicorn.pid"
