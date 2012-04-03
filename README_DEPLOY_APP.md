# Deploying MaaSive Web

We use Capistrano to deploy, if you aren't familiar with it check out [Getting Started with Capistrano](https://github.com/capistrano/capistrano/wiki/2.x-Getting-Started), the [Default Deployment Beahavior cheatsheet](https://github.com/mpasternacki/capistrano-documentation-support-files/raw/master/default-execution-path/Capistrano%20Execution%20Path.jpg) and the [List of Capistrano tasks](https://github.com/capistrano/capistrano/wiki/Capistrano-Tasks) before starting.

## Directory structure

The names of the directories depend on some variables located in _deploy.rb_, and _config/{environment}.rb_, let's say we have this configuration:

	set :application,     "mymaasive.com"
	set :user,            "deployer"
	set :group,       	  "your_group"
	set :deploy_env,	  "staging"
	set :app_parent_path, "/home/deployer/my_sites"
	set :app_dir_name,    "#{deploy_env}.#{application}"
	set :deploy_to,       "#{app_parent_path}#{app_dir_name}"

Then we will have:

	deploy_to = /home/deployer/my_sites/staging.maasiveapi.com
	releases  = /home/deployer/my_sites/staging.maasiveapi.com/releases
	shared    = /home/deployer/my_sites/staging.maasiveapi.com/shared

## Servers

Define your servers in _config/deploy/{environment}.rb_

If you are going to use the same server for application servers, web server and DB server then:

	server 'your_server_01', :app, :db, :web, :primary => true
	server 'your_server_02', :app, :db, :web
	server 'your_server_N',  :app, :db, :web

## Required software

* Git
* Ruby
* Rails
* mySQL
* MongoDB

## Capistrano

### Environments

We use staging as our default environment, so:

To execute task in staging:

    cap deploy

or

	cap staging deploy
	
To execute task in production:

	cap production deploy

### Setting up

We need to have the necessary directory structure for Capistrano and MaaSive Web to work, besides we need RVM, Ruby 1.9.2, a gemset called _maasiveweb_ (you can customize this setting up the _rvm\_ruby\_string_ variable in deploy.rb) and the Bundler gem, the following task will satisfy all these dependencies:

	cap deploy:setup
	
It might take some time since it has to download/install RVM and download/compile/install Ruby.

### Checking dependencies

Now we need to make sure our servers have all we need to deploy, Capistrano helps us with that too, just execute this task:

	cap deploy:check

If Capistrano did not complain about anything then it's time to do our first deployment.

### First deployment

Since it'll be our first time or in Capistrano words, a cold deployment, we need to execute the following task:

	cap deploy:cold
	
We're done, visit your servers and check if the app is running.  

From now on, every time you want to deploy you just have to execute:

	cap deploy
	
That's it regarding deploying MaaSive Web

## MaaSive API

[Click here to go to the instructions to deploy MaaSive API](https://github.com/elc/maasive-api/blob/master/README_DEPLOY_APP.md).