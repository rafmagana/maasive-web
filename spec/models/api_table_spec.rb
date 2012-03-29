require 'spec_helper'

describe ApiTable do
  
  describe ".build_query" do
    
    before(:each) do
      @at = ApiTable.new(:schema => {"user_id"=>"String", "age"=>"Float", "title" => "String"})
    end
    
    it "should map eql to a basic key value association" do
      @at.build_query("user_id.eql" => 12).should == { "user_id" => "12" }
    end
    
    it "should map multiple eqls to a basic key value association" do
      @at.build_query("user_id.eql" => 12, "title.eql" => "Hello").should == { "user_id" => "12", "title" => "Hello" }
    end
    
    it "should map multiple gt and lt to a basic key value association" do
      @at.build_query("age.gt" => 18, "age.lt" => 30).should == { "age" => { "$gt" => 18, "$lt" => 30} }
    end
    
    it "should map lte and gte to a basic key value association" do
      @at.build_query("age.lte" => 18, "age.gte" => 30).should == { "age" => { "$lte" => 18, "$gte" => 30} }
    end
    
    it "should typecase values to the columns type" do
      @at.build_query("age.gt" => "18.2", "age.lt" => "30.0").should == { "age" => { "$gt" => 18.2, "$lt" => 30.0} }
    end
    
    it "should parse a given regexp" do
      @at.build_query("title.regexp" => "/awesome/i").should == { "title" => /awesome/i }
    end
    
    it "should throw and error if given and invalid regexp" do
      @at.build_query("title.regexp" => "/*/i").should == { "error" => "Could not parse RegExp on key: title.regexp" }
    end
    
    describe "nested queries" do
      
      it "should build a query with an or statement" do
        @at.build_query("or.age.lt" => "18.0", "or.age.gt" => "30.0").should == {"$or"=>[{"age"=>{"$lt"=>18.0}}, {"age"=>{"$gt"=>30.0}}]} 
      end
      
      it "should build query with an or statement with nested eqls" do
        @at.build_query("or.user_id.eql" => "def456", "or1.user_id.eql" => "abc123").should == {"$or"=>[{"user_id"=>"def456"}, {"user_id" => "abc123"}]} 
      end
      
    end
    
  end
  
end
