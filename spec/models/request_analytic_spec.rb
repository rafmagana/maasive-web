require 'spec_helper'

describe RequestAnalytic do
  
  before(:each) do
    @app = App.make
  end
  
  describe "#add_created_at" do
    
    it "should add the epoc_created_at to each RequestAnalytic on create" do
      @r = RequestAnalytic.create
      @r.epoc_created_at.should_not be_nil
    end
    
  end
  
  describe ".create_for_app_from_env_with" do
    
    before(:each) do
      @env = {
         "HTTP_HOST"            => "http://example.com",
         "HTTP_TIMEZONE"        => "Pacific/Los Angeles",
         "HTTP_USER_AGENT"      => "MaasiveWebAlpha",
         "HTTP_DEVICE_ID"       => "d0abdee6fef499ef7a71f4b1fec02a44b2090c66",
         "HTTP_DEVICE_NAME"     => "iPhone OS",
         "HTTP_DEVICE_VERSION"  => "4.3.3"
      }
      @params = {
          "app_id"=>"4ddd7647d0edf47e7b000007", 
          "version_hash"=>"5851299f381008ad5e8a6b8f81a568003526a78e", 
          "name"=>"Task", 
          "controller"=>"endpoint", 
          "action"=>"index"
      }
    end
    
    it "should create a new RequestAnalytic with the given app_id" do
      lambda {
        @r = RequestAnalytic.create_for_app_from_env_with(@app.identifier.to_s, @env, @params)
      }.should change(RequestAnalytic, :count).by(1)
      @r.app_id.should == @app.identifier.to_s
    end
    
    { :host            => "HTTP_HOST",
      :timezone        => "HTTP_TIMEZONE",
      :user_agent      => "HTTP_USER_AGENT",
      :device_id       => "HTTP_DEVICE_ID",
      :device_name     => "HTTP_DEVICE_NAME",
      :device_version  => "HTTP_DEVICE_VERSION" }.each do |key, value|
    
      it "should save #{value} into #{key} on the new" do
        @r = RequestAnalytic.create_for_app_from_env_with(@app.identifier.to_s, @env, @params)
        @r[key].should == @env[value]
      end
        
    end
    
  end
  
end
