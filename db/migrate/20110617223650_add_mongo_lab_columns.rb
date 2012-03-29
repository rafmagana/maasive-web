class AddMongoLabColumns < ActiveRecord::Migration
  def self.up
    add_column :apps, :mongo_url, :string
  end

  def self.down
    remove_column :apps, :mongo_url
  end
end
