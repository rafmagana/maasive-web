class VersionsController < ApplicationController
  respond_to :json, :html
  
  prepend_before_filter :require_developer_or_app
  
  def index
    @versions = Version.where(:app_id => params[:app_id])
  end
  
  def show
    @version = Version.find_by_version_hash_and_app_id(params[:id].to_f, params[:app_id])
    respond_with @version
  end
  
  def new
    
  end

  # def create
  #   last_version = Version.sort(:version_number.desc).find_by_app_id(params[:app_id])
  #   
  #   new_version_num = last_version.nil? ? Version::Start : last_version.version_number + Version::Increment
  #   
  #   version = Version.create(version_number: new_version_num, app_id: params[:app_id])
  #   
  #   params[:version].each do |table_name, schema|
  #     version.api_tables.create({
  #       name: table_name,
  #       schema: schema,
  #       app_id: params[:app_id],
  #       version_number: new_version_num
  #     });
  #   end
  #   
  #   render :json => version
  # end
  
  def create
    version = Version.find_or_initialize_by_version_hash_and_app_id(params[:version_hash], params[:app_id])
    
    if (version.new_record?)
      params[params[:version_hash]].each do |table_name, schema|
        schema.delete("_id")
        version.api_tables.create({
          name: table_name,
          schema: schema,
          app_id: params[:app_id],
          version_hash: params[:version_hash]
        });
      end
      
      version.save
    end
    
    render :json => version
  end
  
  def destroy
    raise [params[:id], current_app.identifier].map(&:inspect).join(' : ')
    render :text => Version.find_by_version_hash_and_app_id_and_name(params[:id], current_app.identifier, params[:name]).inspect
    
  end
  
end