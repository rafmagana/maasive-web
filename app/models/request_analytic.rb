class RequestAnalytic
  include MongoMapper::Document
  
  key :app_id,          String
  key :host,            String
  key :timezone,        String
  key :user_agent,      String
  key :device_id,       String
  key :device_name,     String
  key :device_version,  String
  key :params,          Object
  
  key :epoc_created_at, Integer
  
  before_create :add_created_at
  
  def add_created_at
    self.epoc_created_at = Time.now.utc.to_i
  end
  
  def self.create_for_app_from_env_with(app_id, env, params)
    self.create({
      :app_id          => app_id,
      :host            => env["HTTP_HOST"],
      :timezone        => env["HTTP_TIMEZONE"],
      :user_agent      => env["HTTP_USER_AGENT"],
      :device_id       => env["HTTP_DEVICE_ID"],
      :device_name     => env["HTTP_DEVICE_NAME"],
      :device_version  => env["HTTP_DEVICE_VERSION"],
      :access_type     => params[:controller],
      :params          => params
    })
  end
  
  ## HOURLY REQUEST
  
  def self.hourly_statistics(query = {})
    ending_time   = Time.now.ceil(1.hour)
    starting_time = ending_time - 12.hours
    
    query.merge!({:epoc_created_at => {:$gt => starting_time.to_i, :$lt => ending_time.to_i}})
    # ((Time.now - Time.now.beginning_of_day) / 1.hour).floor
    h = {}
    self.collection.map_reduce(self.map_hourly, self.reduce_hourly, :query => query, :out => { :inline => 1}, :raw => true)["results"].each do |f| 
      h[f["_id"].to_i.to_s] = f["value"]["count"]
    end if self.exists?
    h
  end
  
  def self.map_hourly
    <<-JS
    function(){
      var hour = Math.floor((this.epoc_created_at - #{Time.now.ceil(1.hour).to_i}) / 3600);
      emit(hour, { count: 1 })
    }
    JS
  end
  
  def self.reduce_hourly
    <<-JS
    function( key , values ){
        var total = 0;
        for ( var i=0; i<values.length; i++ ) total += values[i].count;
        return { count: total };
    }
    JS
  end
  
  ## PER DEVICE BREAKOUT
  
  def self.device_statistics(query = {})
    ending_time   = Time.now.ceil(1.hour)
    starting_time = ending_time - 24.hours  
    query.merge!({:epoc_created_at => {:$gt => starting_time.to_i, :$lt => ending_time.to_i}})
    # ((Time.now - Time.now.beginning_of_day) / 1.hour).floor
    h = {}
    self.collection.map_reduce(self.map_device, self.reduce_device, :query => query, :out => { :inline => 1}, :raw => true)["results"].map do |f| 
      [f["_id"], f["value"]["count"]]
    end if self.exists?
  end
  
  def self.map_device
    <<-JS
    function(){
      if (this.device_version) {
        emit(this.device_name + " (" + this.device_version+ ")", { count: 1 });
      } else {
        emit("Web", { count: 1 });
      }
    }
    JS
  end
  
  def self.reduce_device
    <<-JS
    function( key , values ){
        var total = 0;
        for ( var i=0; i<values.length; i++ ) total += values[i].count;
        return { count: total };
    }
    JS
  end
  
  ## PER TABLE BREAKOUT
  
  def self.table_statistics(query = {})
    ending_time   = Time.now.ceil(1.hour)
    starting_time = ending_time - 24.hours  
    query.merge!({:epoc_created_at => {:$gt => starting_time.to_i, :$lt => ending_time.to_i}})
    # ((Time.now - Time.now.beginning_of_day) / 1.hour).floor
    h = self.collection.map_reduce(self.map_table, self.reduce_table, :query => query, :out => { :inline => 1}, :raw => true)["results"].map do |f| 
      {:name => f["_id"], :data => [f["value"]["count"]]}
    end if self.exists?
    h
  end
  
  def self.map_table
    <<-JS
    function(){
      emit(this.access_type, { count: 1 });
    }
    JS
  end
  
  def self.reduce_table
    <<-JS
    function( key , values ){
        var total = 0;
        for ( var i=0; i<values.length; i++ ) total += values[i].count;
        return { count: total };
    }
    JS
  end
  

  
end
