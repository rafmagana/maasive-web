class ServicesController < ApplicationController

  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }

  def index
    @current_services = current_app.services || []
    @services         = Service.available_for_developer(current_developer) - @current_services
    @selected_app_tab = :services
  end

  def show
    @service = Service.find(params[:id])
  end

  def add
    @service = Service.find(params[:id])
    render and return if request.get?

    app = App.find(params[:app][:id])
    @service.contracts.create(:app => app)
    redirect_to root_url
  end

end
