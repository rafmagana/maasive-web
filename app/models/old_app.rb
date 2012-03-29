class OldApp
  include MongoMapper::Document

  key :account_id, Integer
  key :name, String
  
  set_collection_name :apps

  timestamps!
end