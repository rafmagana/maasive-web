class Account::ServicesController < ApplicationController
  
  prepend_before_filter :require_admin
  
  add_breadcrumb "Dashboard", :root_path
  before_filter :load_account


  def index
    @services = @account.services
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
  end

  def create
    @service = Service.new(params[:service])
    @service.account_id = @account.id
    if @service.save
      redirect_to :action => :index
    else
      render :new
    end
  end
  
  def edit
    @service = Service.find(params[:id])
  end
  
  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      redirect_to :action => :index
    else
      render :edit
    end
  end
  
  protected
  
  def load_account
    @account = Account.find(params[:account_id])
  end

end
