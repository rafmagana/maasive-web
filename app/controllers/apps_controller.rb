class AppsController < ApplicationController
  # include Devise::Controllers::InternalHelpers

  before_filter :require_developer
  before_filter :set_app_id
  before_filter :load_accounts
  add_breadcrumb "Dashboard", :root_path
    
  def index
    redirect_to :controller => :dashboards, :action => :show
  end
  
  def new
    @app = App.new
  end
  
  def create
    @app = App.new(params[:app])
    if @app.save
      redirect_to app_path(@app.identifier)
    else
      render :action => :new 
    end    
  end
  
  def show
    @app = current_app
    @selected_app_tab = :keys
  end
  
  def secret_key
    render :text => current_app.secret_key
  end
  
  def edit
    @app = current_app
    if current_developer.admin? and current_developer.accounts.select { |a| a == @app.account }.blank?
      @accounts.unshift current_app.account
    end
    add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }
    @selected_app_tab = :edit
    
  end
  
  def authenticate
    cookies["_app_token"] = current_app.cookie_value
    redirect_to '/'
  end
  
  def update
    @app = current_app
    if @app.update_attributes(params[:app])
      redirect_to :action => :show
    else
      render :action => :edit
    end
    add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }
    
  end
  
  def destroy
    @app = current_app
    if @app.destroy
      redirect_to '/'
    else
      render :action => :show
    end
  end
  
  protected
  
  def current_app
    super || current_developer.apps.find_by_identifier(params[:id])
  end

  def set_app_id
    params[:app_id] = params[:id]
  end
    
end
