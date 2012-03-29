class DashboardsController < ApplicationController
  
  before_filter :require_developer, :except => [:what_is_maasive, :about]
  
  def show
    if current_developer.admin?
      @apps     = App.all
      @accounts = Account.includes(:apps, :services, :developers).all
    else
      @apps     = current_developer.apps
      @accounts = current_developer.accounts
    end
  end

  def what_is_maasive
  end

  def about
  end

end
