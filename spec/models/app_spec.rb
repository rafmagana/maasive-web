require 'spec_helper'

describe App do
  
  describe "on creation" do
    
    before(:each) do
      @app = App.create
    end
    
    it "should have the mongo host and port set to the current environments" do
      @app.mongo_host.should == MongoMapper.config[Rails.env]['host']
      @app.mongo_port.should == MongoMapper.config[Rails.env]['port']
    end
    
    it "should have and identifier and secret key" do
      @app.identifier.should_not be_nil
      @app.secret_key.should_not be_nil
    end
    
  end
  
end
