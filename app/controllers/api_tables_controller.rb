class ApiTablesController < ApplicationController
  
  before_filter :require_developer
  
  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }
  
  def index
    api_table = ApiTable.where(:app_id => params[:app_id]).sort(:created_at.desc).first
    
    redirect_to "/apps/#{current_app.identifier}/versions/#{api_table.version_hash}/#{api_table.name}" if api_table
    
  end
  
  def destroy
    @table = ApiTable.first(:app_id => params[:app_id], :version_hash => params[:id], :name => params[:name])
    if @table.destroy
      redirect_to :action => :index
    else
      redirect_to :back
    end
  end
  
  def destroy_all
    @tables = ApiTable.where(:app_id => params[:app_id], :name => params[:id])
    if @tables.all? { |t| t.destroy }
      redirect_to :action => :index
    else
      redirect_to :back
    end
  end
  
end
