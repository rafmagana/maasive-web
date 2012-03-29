class ApiTable
  
  include MongoMapper::Document
  
  # key :_id, String, :default => lambda { BSON::ObjectId.new }
  
  key :app_id,          String
  key :version_hash,    String
  key :name,            String
    
  key :schema,          Hash
  
  timestamps!
  
  belongs_to :version
  
  validates_presence_of :app_id
  validates_presence_of :version_hash
  validates_presence_of :name
  
  def app
    return @app if @app
    @app = App.find_by_identifier(self.app_id)
  end
  
  def short_version_and_created_at
    "#{version_hash[0..7]} #{self.created_at}"
  end
  
  def build_query(params)
    query = {}
    
    params.each do |k,value|
      key_array = k.to_s.split(".")
      begin
        build_sub_query(query, key_array, value)
      rescue Syck::TypeError
        return { "error" => "Could not parse RegExp on key: #{k}"}
      rescue RegexpError
        return { "error" => "Could not parse RegExp on key: #{k}"}
      rescue StandardError => e
        return { "error" => "There was an error on key: #{k}"}
      end
    end
    
    query
  end
  
  MONGO_KEYS  = ["gt", "gte", "lt", "lte", "ne"]
  
  def build_sub_query(query, key_array, value, last_key=nil)
    current_key = key_array.slice!(0)
    if current_key
      if current_key.match(/^or\d*$/) && !last_key
        query['$or'] ||= [];
        query['$or'] = build_or_sub_query(query['$or'], key_array, value)
      elsif current_key == "regexp"
        query = YAML.load("!ruby/regexp #{value}")
      elsif current_key == "in"
        query["$in"] = value.split(",").map { |v| type_cast_value(v, for: last_key)}
      elsif MONGO_KEYS.include?(current_key)
        query['$'+current_key] = type_cast_value(value, for: last_key)
      elsif !key_array.empty?
        query[current_key] ||= {}
        query[current_key] = build_sub_query(query[current_key], key_array, value, current_key)
      elsif current_key == "eql"
        query = type_cast_value(value, for: last_key)
      else
        query = type_cast_value(value, for: last_key)
      end
    else
      query = type_cast_value(value, for: last_key)
    end
    query
  end
  
  def build_or_sub_query(array, key_array, value, last_key=nil)
    current_key = key_array.slice!(0) 
    query = {}
    query[current_key] = build_sub_query({}, key_array, value, current_key)
    array << query
    array
  end
  
  def model
    conf = self
    klass = Class.new do
      include MongoMapper::Document
      
      cattr_accessor :configuration
      self.configuration = conf
      
      @app = App.find_by_identifier(conf.app_id)
      

      configuration.schema.each do |k,v|
        case v
        when "String"
          self.key k.to_sym, String, :default => ""
        when "Boolean"
          self.key k.to_sym, Boolean, :default => false
        when "Integer"
          self.key k.to_sym, Integer, :default => 0
        when "Date"
          self.key k.to_sym, Time
          self.class_eval("def #{k}_epoc=(value); old_zone = Time.zone; Time.zone = 'UTC'; self['#{k}'] = Time.zone.at(value.to_i / 1000); Time.zone= old_zone; end;")
          self.class_eval("def #{k}_epoc; self['#{k}'] ? self['#{k}'].to_time.to_i * 1000 : nil; end;")

        when "EncryptedString"
          self.key k.to_sym, String
          self.class_eval("def #{k}_encrypt=(value); self._encrypt_mongo_attribute('#{k}', value, '#{conf.app_id}', '#{@app.secret_key}') unless value.blank?; end;")
        when "Float"
          self.key k.to_sym, Float, :default => 0.0
        else
          self.class_eval("def #{k}; 'Type #{v} not supported'; end;")
        end
      end
      
      
      def self.collection
        return @collection if @collection
        config      = MongoMapper.config[Rails.env]
        
        if MongoMapper.connection.is_a?(Mongo::ReplSetConnection)
          @connection = Mongo::ReplSetConnection.new(*config["hosts"], :read_secondary => true)
        else
          @connection = Mongo::Connection.new( @app.mongo_host, @app.mongo_port )
        end
        
        @db         = @connection.db(configuration.app_id)
        @db.authenticate(configuration.app_id, @app.secret_key)
        
        @collection = @db.collection(configuration.name)
      end
      
      timestamps!
      
      def self.name
        configuration.name.singularize.camelcase
      rescue
        "Table"
      end

      protected
      
      def _encrypt_mongo_attribute(k, v, app_id, secret_key)
        self[k] = App.sign_for_app_id(v, app_id, secret_key)
      end
      
    end
    klass
  end
  
  def as_json(options={})
    super((options || {}).merge(:except => [:_id, :version_id]))
  end

  def to_csv
    require 'csv'
    csv = nil
    headers = ['id']
    columns = ['_id']

    self.schema.each do |column, v|
      columns << column
    end

    headers += columns[1..-1]

    csv_string = CSV.generate do |csv|
      csv << headers
      model.all.each do |i|
        content = []
        columns.each do |c|
          content << i.send(c)
        end
        csv << content
      end
    end
  end

  protected
  
  def type_cast_value(raw, options)
    type = self.schema[options[:for]]
    return ["true", "1", "t"].include?(raw.downcase) if options[:for] == "_deleted"
    return raw unless type
    case type
    when "Float"
      return raw.to_f
    when "String"
      return raw.to_s
    when "Integer"
      return raw.to_i
    when "Boolean"
      return ["true", "1", "t"].include?(raw.downcase)
    when "EncryptedString"
      return raw
    else
      return raw
    end
  end
  
end
