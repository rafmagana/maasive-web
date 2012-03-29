class StatisticsController < ApplicationController
  
  before_filter :authenticate_developer!

  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }
  
  # RequestAnalytic.all.each { |r| if rand(2) > 0; r.params["controller"] = 'service_connection'; r.save; puts "HELLO"; end }; nil
  # RequestAnalytic.all.each { |r| if rand(3) > 1; r.update_attributes({:device_version => ["A","B","C"].sample,:device_name => ["D","E","F"].sample}); puts "UPDATED"; end }

  def show
    total_hourly         = RequestAnalytic.hourly_statistics(:app_id => params[:app_id], "access_type" => "endpoint" )
    # total_hourly_service = RequestAnalytic.hourly_statistics(:app_id => params[:app_id], "access_type" => "service_connections")
    
    @total_hourly_data          = (-12..-1).map { |hour| total_hourly[hour.to_s] || 0 }
    # @total_hourly_data_service  = (-12..-1).map { |hour| total_hourly_service[hour.to_s] || 0 }
    
    @device_data  = RequestAnalytic.device_statistics(:app_id => params[:app_id])

    @table_data   = RequestAnalytic.table_statistics(:app_id => params[:app_id])
    
    
    @selected_app_tab = :stats
    respond_to do |format|
      format.html
    end
  end

end