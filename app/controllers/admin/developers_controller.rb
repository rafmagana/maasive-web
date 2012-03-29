class Admin::DevelopersController < Admin::ApplicationController
  
  add_breadcrumb "Dashboard", :root_path
  
  def index
    @developers = Developer.all
  end
  
  def new
    @developer  = Developer.new
  end
  
  def import
   if request.post?
    params[:users].each_line do |email|
      dev = Developer.invite!(:email => email.strip.downcase)
    end
    flash[:notice] = "Developers invited"
   end
  end

  def edit
    @developer  = Developer.find(params[:id])
  end
  
  def hijack
    sign_in(:developer, Developer.find(params[:id]))
    redirect_to '/'
  end
  
  def create
    @developer  = Developer.new(params[:developer])
    if Developer.invite!(:email => params[:developer][:email])
      redirect_to :action => :index
    else
      render :new
    end
  end
  
  def update
    @developer  = Developer.find(params[:id])
    @developer.beta_access = params[:developer][:beta_access]
    if @developer.update_attributes(params[:developer])
      redirect_to :action => :edit
    else
      render :edit
    end
  end
  
end
