require 'machinist/active_record'
require 'machinist/mongo_mapper'
require 'faker'

Developer.blueprint do
  name            { Faker::Name.name }
  email      { Faker::Internet.email }
  password              { "billyjoe" }
  password_confirmation { "billyjoe" }
  has_signed_nda { true }
end

App.blueprint do
  name { Faker::Company.name }
  account_id { Account.last.try(:id) || 1 }
end

Version.blueprint do
  app_id { App.make.identifier }
  version_hash { "ef547badb8b0801d06a93155cc052341c749d1c0" }
end

ApiTable.blueprint do
  version_hash { "ef547badb8b0801d06a93155cc052341c749d1c0" }
  name { "People" }
  schema {
    {"name" => "String", "age" => "Float"}
  }
end

Service.blueprint do
  base_port   { 3333 }
  base_url    { "localhost" }
  description { "Awesome" }
  subtitle    { "Sweet" }
  title       { "Test Service" }
end

ServiceConnection.blueprint do
  app { App.make }
  service { Service.make }
end


class Version
  class << self
    def make_with_api_table(name = :people, options = {})
      v = Version.make(name)
      a = ApiTable.make(name, :app_id => v.app_id, :version_hash => v.version_hash )
      v.api_tables << a
      v.save
      v
    end
  end
end