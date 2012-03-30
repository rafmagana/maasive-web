# Setting up MaaSive

Our application is broken out into two main parts:

* [*MaaSive Web*](https://github.com/elc/maasive-web), a Rails app made for front end users to login and setup
  their mobile apps. This is also where documentation and statistics are viewed.
* [*MaaSive API*](https://github.com/elc/maasive-api), a Node.js app for the frameworks (iOS, Windows Phone,
  Android) to connect only.

Both applications use mySQL 5.5.* and MongoDB 2.0.*.

There are also services (like push or email) that have their own setup
processes.

Although we recommend you to install the software specific versions mentioned in this guide, if you already have MongoDB, mySQL, Ruby, the Bundler gem and Node.js working in your system skip to and [Clone repository](#clonerepo)

## Before starting

Make sure you have the building tools necessary to compile C and C++ applications (make, gcc, g++, etc)

### Mac users

Install *Xcode 4.2* at least, make sure you install the Command Line Tools.

### Linux users

#### Debian or Debian-based distros 

	$ sudo apt-get install build-essential
	
#### Red Hat or Red Hat-based distros (CentOS, Fedora)

	$ yum groupinstall "Development Tools"
	
or

	$ yum install gcc gcc-c++ kernel-devel
	
## Database engines

Make sure you have [MongoDB 2.0.*](http://www.mongodb.org/downloads) and [mySQL 5.5](http://dev.mysql.com/downloads/mysql/) up and running

## Getting MaaSive Web (Rails) application running

### Install RVM

    http://beginrescueend.com/rvm/install/

### Install Ruby 1.9.2

We use ruby-1.9.2-p180 via RVM

    $ rvm install ruby-1.9.2-p180

#### Install Bundler in the global gemset

    $ rvm use ruby-1.9.2-p180@global
    $ gem install bundler

#### Make ruby-1.9.2-p180 the default ruby

    $ rvm --default use 1.9.2-p180

#### Create RVM Gemset

    $ rvm use ruby-1.9.2-p180@maasive --create

### <a name='clonerepo'></a> Clone repository

    $ git clone git@github.com:elc/maasive-web.git
    $ cd maasive-web

### Install dependencies

    $ bundle install

### Setup the database

Edit *config/database.yml* accordingly then

    $ rake db:setup

### Test users

At this point you have an admin and a regular user to login with, these are the credentials:

Admin

    email = admin@domain.com
    password = loremadmin

Regular

	email = user@domain.com
	password = loremipsum

### Run your server

    $ rails server

Then log into [http://localhost:3000/](http://localhost:3000/) with your email and password.

## Getting MaaSive API (Node.js) application running

[Click here to go to the instructions to setup MaaSive API locally](https://github.com/elc/maasive-api/blob/master/README_APP_SETUP.md)