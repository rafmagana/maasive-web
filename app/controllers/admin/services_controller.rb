class Admin::ServicesController < Admin::ApplicationController

  def index
    @services = Service.all
  end

  def show
    @service = Service.find(params[:id])
  end

  def new
    @service = Service.new
    @service.service_documentation_page = ServiceDocumentationPage.new
  end

  def create
    @service = Service.new(params[:service])
    if @service.save
      redirect_to :action => :index
    else
      render :new
    end
  end
  
  def edit
    @service = Service.find(params[:id])
    @service.service_documentation_page ||= ServiceDocumentationPage.new
  end
  
  def update
    @service = Service.find(params[:id])
    if @service.update_attributes(params[:service])
      redirect_to :action => :index
    else
      render :edit
    end
  end

  def destroy
    @service = Service.find(params[:id])
    @service.destroy
    redirect_to :action => :index
  end
  
  protected
  
  def load_account
    @account = Account.find(params[:account_id])
  end

end
