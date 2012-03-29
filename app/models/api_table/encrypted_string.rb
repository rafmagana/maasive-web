class ApiTable
  
  class EncryptedString < String
    attr_accessor :translations

    def initialize( translations = {} ) 
      raise self.inspect
    end 

    def self.from_mongo(value)
      value
    end

    def self.to_mongo(value)
      value
    end    
  end
  
end