class Admin::StatisticsController < Admin::ApplicationController
  
  def show
    total_hourly         = RequestAnalytic.hourly_statistics("access_type" => "endpoint" )
    total_hourly_service = RequestAnalytic.hourly_statistics("access_type" => "service_connections")
    
    @total_hourly_data          = (-12..-1).map { |hour| total_hourly[hour.to_s] || 0 }
    @total_hourly_data_service  = (-12..-1).map { |hour| total_hourly_service[hour.to_s] || 0 }
    
    @device_data  = RequestAnalytic.device_statistics()

    @table_data   = RequestAnalytic.table_statistics()
    
    @selected_app_tab = :stats
    respond_to do |format|
      format.html
    end
  end
  
end
