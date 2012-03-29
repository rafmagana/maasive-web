require 'spec_helper'

describe StatisticsController do
  include Devise::TestHelpers
  
  before(:each) do
    @app = App.make
    @developer = Developer.make
    
    sign_in @developer
    
    Timecop.freeze(2.hours.ago) do
      [
        {"params" => {"controller"=>"endpoint", "action"=>"create", "app_id"=>@app.identifier.to_s, "version_hash"=>"f09ef761f849052e9d18cb4470d7db7b5692879e", "name"=>"Task", "format"=>"json"}}, 
        {"params" => {"controller"=>"endpoint", "action"=>"create", "app_id"=>@app.identifier.to_s, "version_hash"=>"f09ef761f849052e9d18cb4470d7db7b5692879e", "name"=>"Task", "format"=>"json"}}, 
        {"device_version" => "5.0.1"}
      ].each { |attrs| create_ra_with(attrs) }
    end
    
    Timecop.freeze(1.hour.ago) do
      [
        {"device_name"    => "Android", "device_version" => "2.2"}, 
        {"device_version" => "5.0.1"}
      ].each { |attrs| create_ra_with(attrs) }
    end

    [
      {"device_name"    => "Android", "device_version" => "2.2.3"}, 
      {"params" => {"controller"=>"endpoint", "action"=>"create", "app_id"=>@app.identifier.to_s, "version_hash"=>"f09ef761f849052e9d18cb4470d7db7b5692879e", "name"=>"Task", "format"=>"json"}}, 
      {"device_version" => "2.0.1"}
    ].each { |attrs| create_ra_with(attrs) }

  end

  describe "show" do
    
    it "should show correctly hourly total request statistics for the given app" do
      get :show, :app_id => @app.identifier.to_s
      response.should be_success
      @data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 3.0, 2.0, 3.0]
      assigns[:total_hourly_data].should == @data
    end
    
    # it "should show correctly hourly get request statistics for the given app" do
    #   get :show, :app_id => @app.identifier.to_s
    #   response.should be_success
    #   @data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #   @data[Time.now.hour] = 2.0
    #   @data[Time.now.hour - 1] = 2.0
    #   @data[Time.now.hour - 2] = 1.0
    #   assigns[:get_hourly_data].should == @data
    # end
    
    # it "should show correctly hourly post request statistics for the given app" do
    #   get :show, :app_id => @app.identifier.to_s
    #   response.should be_success
    #   @data = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    #   @data[Time.now.hour] = 1.0
    #   @data[Time.now.hour - 1] = 0
    #   @data[Time.now.hour - 2] = 2.0
    #   assigns[:post_hourly_data].should == @data
    # end
    
  end
  
  
  def ra_attrs_with(options={})
    {"access_type" => "endpoint", "app_id"=>@app.identifier.to_s, "host"=>"www.awesome.com", "timezone"=>"America/Los_Angeles", "user_agent"=>"MaasiveWeb", "device_id"=>"d0abdee6fef499ef7a71f4b1fec02a44b2090c66", "device_name"=>"iPhone OS", "device_version"=>"4.3.3", "params"=>{"controller"=>"endpoint", "action"=>"index", "app_id"=>@app.identifier.to_s, "version_hash"=>"f09ef761f849052e9d18cb4470d7db7b5692879e", "name"=>"Task", "format"=>"json"}}.merge(options)
  end
  
  def create_ra_with(options={})
    RequestAnalytic.create(ra_attrs_with(options))
  end
  
end
