require 'spec_helper'

describe VersionsController do
  
  describe "#create" do
    
    before(:each) do
      @app         = App.make
      @api_hash    = Digest::SHA1.hexdigest("age:Float,name:String,")
      @schema = {
        "name" => "String",
        "age" => "Float"
      }
      @dev       = Developer.make
      sign_in @dev
    end
    
    it "should create a new version of the given schema" do
      Version.find_by_version_hash_and_app_id(@api_hash, @app.identifier).should be_nil
      post :create, :app_id => @app.identifier.to_s, :version_hash => @api_hash, @api_hash => { "People" => @schema }
      Version.find_by_version_hash_and_app_id(@api_hash, @app.identifier).should_not be_nil
    end
    
    it "should create and api table with the schema, app_id, and version_hash for the version" do
      post :create, :app_id => @app.identifier.to_s, :version_hash => @api_hash, @api_hash => { "People" => @schema }
      @version = Version.find_by_version_hash_and_app_id(@api_hash, @app.identifier)
      @version.api_table.should_not be_nil
      @version.api_table.schema.should       == @schema
      @version.api_table.app_id.should       == @app.identifier.to_s
      @version.api_table.version_hash.should == @api_hash
    end
    
  end
  
end
