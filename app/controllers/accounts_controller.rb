class AccountsController < ApplicationController
  
  add_breadcrumb "Dashboard", :root_path
  
  before_filter :authenticate_developer!
  before_filter :load_accounts, :only => :index
  
  def index
    redirect_to :controller => :dashboards, :action => :show
  end
  
  def new
    @account = Account.new
  end
  
  def create
    @account = Account.new(params[:account])
    @account.developers << current_developer
    if @account.save
      redirect_to :controller => :dashboards, :action => :show
    else
      render :action => :new 
    end
  end
  
  def edit
    @account = current_developer.accounts.find(params[:id])
  end
  
  def update
    @account = current_developer.accounts.find(params[:id])
    
    @account = Account.find(@account.id) ## this is mega stupid but you get ActiveRecord::ReadOnlyRecord unless you do this
    
    if @account.update_attributes(params[:account])
      redirect_to :controller => :dashboards, :action => :show
    else
      render :action => :edit
    end
  end
  
end