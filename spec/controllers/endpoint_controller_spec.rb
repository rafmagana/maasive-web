require 'spec_helper'

describe EndpointController do
  include Devise::TestHelpers
  
  
  before(:each) do
    @version   = Version.make_with_api_table
    @app       = @version.app
    @api_table = @version.api_table
    @dev       = Developer.make
    sign_in @dev
  end
  
  describe "#new" do
    
    it "should init a new instance of the class generated from the api table" do
      get :new, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name
      response.should be_success
      assigns(:instance).class.configuration.should == @api_table
    end
    
    it "should save a request analytic" do
      lambda { get :new, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name }.should save_request_analytic
    end
    
  end
  
  describe "#create" do
    
    it "should create a new instance of the class generated from the api table" do
      lambda {
        post :create, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, @api_table.name => {
          :name => "Dolorem",
          :age  => 101.1
        }
      }.should change(@api_table.model, :count).by(1)
    end
    
    it "should create a new instance of the class with the attributes given" do
      post :create, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, @api_table.name => {
        :name => "Dolorem",
        :age  => 101.1
      }
      instance = @api_table.model.last
      instance.name.should == "Dolorem"
      instance.age.should  == 101.1
    end
    
    it "should save a request analytic" do
      lambda { post :create, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, @api_table.name => {
        :name => "Dolorem",
        :age  => 101.1
      } }.should save_request_analytic
    end
    
  end
  
  describe "#index" do
    
    describe "with json" do
      
      before(:each) do
        model = @api_table.model
        model.create({ :name => "Dolorem", :age => 72.1 })
        model.create({ :name => "Ipsum",  :age => 82.1 })
        model.create({ :name => "Sit",   :age => 92.1 })
      end

      it "should return an error if the query is invalid" do
        get :index, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, :format => 'json', "title.regexp" => "/*/"
        response.should be_success
        json = JSON.parse(response.body)
        json['error'].should == "Could not parse RegExp on key: title.regexp"
      end
      
      it "should return json resutls of the existing entities on the meta table for the api table" do
        get :index, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, :format => 'json'
        response.should be_success
        json = JSON.parse(response.body)
        json['results'].size.should == 3
      end
      
      it "should return json prefixed by the name of the table" do
        get :index, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, :format => 'json'
        json = JSON.parse(response.body)
        json['results'].map { |i| i.keys.first }.all? { |is| is == "People" }.should be_true
      end
      
      it "should return json with all my boys" do
        get :index, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, :format => 'json'
        json = JSON.parse(response.body)
        people = json['results'].map { |i| i.values }.flatten
        people.any? { |p| p["name"] == "Dolorem"}.should be_true
        people.any? { |p| p["name"] == "Ipsum"}.should be_true
        people.any? { |p| p["name"] == "Sit"}.should be_true
      end
      
      it "should save a request analytic" do
         lambda { get :index, :app_id => @app.identifier.to_s, :version_hash => @api_table.version_hash, :name => @api_table.name, :format => 'json' }.should save_request_analytic
      end
      
    end
    
  end
  
end
