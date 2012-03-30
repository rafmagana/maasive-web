# Setting up MaaSive

Our application is broken out into two main parts:

* *MaaSive Web*, a Rails app made for front end users to login and setup
  their mobile apps. This is also where documentation and statistics are viewed.
* *MaaSive API*, a Node.js app for the frameworks (iOS, Windows Phone,
  Android) to connect only.

Both applications use mySQL 5.5.* and MongoDB 2.0.*.

There are also services (like push or email) that have their own setup
processes.

## Before starting

Make sure you have the building tools necessary to compile C and C++ applications (make, gcc, g++, etc)

### Mac users

Make sure you have *Xcode 4.2* at least

### Linux users

You can find the tools in the *build-essential* package (Debian or Debian-based), the *Development Tools* group (CentOS, RedHat, Fedora), etc.

## Installing databases

### Install MongoDB 2.0.*

### Install mySQL 5.5

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

### Clone repository

    $ git clone git@github.com:elc/maasive-web.git
    $ cd maasive-web

### Install dependencies

    $ bundle install

### Setup the database

Edit config/database.yml accordingly then

    $ rake db:setup

This will create an user you can use to log into the application

    email = admin@domain.com
    password = loremipsum

### Run your server

    $ rails server

Then log into [http://localhost:3000/](http://localhost:3000/) with your email and password.

## Getting MaaSive API (Node.js) application running

### Install NVM (https://github.com/creationix/nvm)

    git clone git://github.com/creationix/nvm.git ~/.nvm

To activate NVM, you need to source it from your bash shell:

    . ~/nvm/nvm.sh

You can add this line to .bash\_profile, .profile, .bashrc, etc.

### Node.js 0.4.12

    $ nvm install v0.4.12
    $ nvm use v0.4.12

If you want to come back to the Node version installed in your system

    # nvm deactivate

### Installing NPM (Node Package Manager)
