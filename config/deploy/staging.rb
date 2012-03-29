require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'rvm/capistrano'

server 'your_staging_server', :app, :web, :primary => true

set :deploy_env,  "staging"
set :app_dir_name, "#{deploy_env}.#{application}"
set :deploy_to, "#{app_parent_path}#{app_dir_name}"
set :rails_env,   "#{deploy_env}"
