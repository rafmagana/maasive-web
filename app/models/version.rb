class Version
  include MongoMapper::Document
  
  key :version_hash, String
  key :app_id, String
  
  def app
    return @app if @app
    @app = App.find_by_identifier(self.app_id)
  end
    
  many :api_tables
  
  def api_table
    self.api_tables.first
  end
  
  timestamps!
  
  def as_json(options={})
    super((options || {}).merge!({:except => :_id, :methods => [:api_tables]}))
  end
end