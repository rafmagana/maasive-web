class EndpointController < ApplicationController
  respond_to :json, :html

  prepend_before_filter :require_developer
  
  before_filter :load_model
  before_filter :load_tables
  before_filter :save_analytics
  before_filter :set_tab

  before_filter :build_query, :only => [:index, :count]

  add_breadcrumb "Dashboard", :root_path
  add_breadcrumb Proc.new { |c| c.current_app.name }, Proc.new { |c| c.app_path(c.current_app.identifier) }

  def index
    if @query["error"]
      respond_to do |format|
        format.html {
          @instances = []
          @errors    = [@query["error"]]
        }
        format.json { 
          render :json => {"error" => @query["error"]}.to_json
        }
      end
    else
      add_breadcrumb "Tables", Proc.new { |c| c.app_api_tables_path }

      @instances = @model.paginate(@query.merge({
        :order    => :created_at.asc,
        :per_page => params[:per_page] || 25, 
        :page     => params[:page] || 1
      }))

      model_name = @model.name.singularize.camelcase

      respond_to do |format|
        format.html
        format.csv do
          app = App.find_by_identifier params[:app_id]
           send_data @api_table.to_csv, :filename => [app.name.split, params[:version_hash], params[:name], Time.now.strftime('%m/%d/%Y-%H-%M')].join('_') + '.csv'
        end
        format.json {
          instances = @instances.map do |e|
            { params[:name] => e }
          end
          render :json => {"results" => instances}.to_json
        }
      end
    end
  end
  
  def count
    if @query["error"]
      respond_to do |format|
        format.json { 
          render :json => {"error" => query["error"]}.to_json
        }
      end
    else
      @count = @model.count(@query)
      respond_to do |format|
        format.json { 
          render :json => {"count" => @count}.to_json
        }
      end
    end
  end
  
  def new
    @instance = @model.new
  end
  
  def create
    attrs = params[params[:name]]
    attrs ||= params[params[:name].downcase]
    attrs.delete(:_id) if attrs[:_id]
    @instance = @model.new(attrs)
    if @instance.save
      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.json { render :json => @instance }
      end
    else
      render :new
    end
  end
  
  def show
    @instance = @model.find(params[:id])
    respond_with @instance
  end
  
  def edit
    @instance = @model.find(params[:id])
  end
  
  def update
    attrs = params[params[:name]]
    attrs ||= params[params[:name].downcase]
    
    attrs.delete(:_id)
    @instance = @model.find(params[:id])
    if @instance.update_attributes(attrs)
      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.json { render :json => @instance.to_json }
      end
    else
      respond_to do |format|
        format.html { render :action => :edit }
        format.json { render :json => @instance.to_json }
      end
    end
  end
  
  def delete
    attrs = params[params[:name]]
    attrs ||= params[params[:name].downcase]
    
    @instance = @model.find(params[:id])
    if @instance.update_attributes({"_deleted" => true})
      respond_to do |format|
        format.html { redirect_to :action => :index }
        format.json { render :json => @instance.to_json }
      end
    else
      respond_to do |format|
        format.html { render :action => :edit }
        format.json { render :json => @instance.to_json }
      end
    end
  end
  

  protected

  def build_query
    @reduced_params = params.reject { |k,v| request.symbolized_path_parameters.has_key?(k.to_sym) }
    @query = {"_deleted" => { "$ne" => true }}.merge!(@api_table.build_query(@reduced_params))
  end
  
  # def load_app
  #   current_developer
  #   return render :status => 401, :text => '401' unless @api_table
  # end
  
  def load_tables
    @api_tables = ApiTable.where(:app_id => params[:app_id]).sort(:created_at.desc).group_by(&:name)
    @api_tables_last_versions = @api_tables.map { |karr| karr[1].first }
    @api_tables_for_current_endpoint = @api_tables[params[:name]]
    
    next_table_index = @api_tables_for_current_endpoint.index {|x|x.version_hash== @api_table.version_hash} + 1
    @next_api_table = (next_table_index >= @api_tables_for_current_endpoint.size) ? @api_tables_for_current_endpoint.last : @api_tables_for_current_endpoint[next_table_index]
  end
  
  def load_model
    @api_table = ApiTable.find_by_app_id_and_version_hash_and_name(params[:app_id], params[:version_hash],params[:name] )
    return render :status => 404, :text => '404' unless @api_table
    @model = @api_table.model
  end
  
  def set_tab
    @selected_app_tab = :tables
  end

end
