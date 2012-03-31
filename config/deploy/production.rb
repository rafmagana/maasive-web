require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

server 'your_server_01', :app, :web, :primary => true
server 'your_server_02', :app, :web
server 'your_server_03', :app, :web
server 'your_server_04', :app, :web

set :deploy_env,  "production"
set :app_dir_name, "#{application}"
set :deploy_to, "#{app_parent_path}#{app_dir_name}"
set :rails_env,   "#{deploy_env}"

set :unicorn_config, "#{current_path}/config/unicorn/#{rails_env}.rb"
