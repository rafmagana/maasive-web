class ServiceConnectionsController < ApplicationController
  
  prepend_before_filter :require_app
  before_filter :load_service
 
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }
  add_breadcrumb "services", Proc.new { |c| c.app_services_path }
  
  before_filter :save_analytics, :only => :run
  
  def show
    @service_connection = @service.service_connections.where( :app_id => current_app.id ).first
    redirect_to :action => :new unless @service_connection
  end
  
  def new    
    @service_connection = ServiceConnection.new(:service => @service, :app => current_app)
  end
  
  def create
    @service_connection = ServiceConnection.new(:service => @service, :app => current_app)
    if @service_connection.save
      redirect_to :action => :show
    else
      render :new
    end
  end
  
  def edit
    @service_connection = @service.service_connections.where( :app_id => current_app.id ).first
    @secure_edit_path   = @service_connection.secure_edit_path    
  end

  def run
    @reduced_params = params.reject { |k,v| request.symbolized_path_parameters.has_key?(k.to_sym) }
    @service_connection = @service.service_connections.where( :app_id => current_app.id ).first
    puts "REDUCED PARAMS: ", params.inspect
    if @service_connection
      response.headers["Content-Type"] = 'application/json'
      render :text => @service_connection.run!(@reduced_params[:command], params)
    else
      render :json => {"errors" => ["The service #{params[:id]} does not exist for this app."]}
    end
  end

  protected
  
  def load_service
    @service = Service.find(params[:service_id])
  end

end
