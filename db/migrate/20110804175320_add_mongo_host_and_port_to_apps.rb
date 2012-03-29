class AddMongoHostAndPortToApps < ActiveRecord::Migration
  def self.up
    add_column :apps, :mongo_host, :string
    add_column :apps, :mongo_port, :integer
  end

  def self.down
    remove_column :apps, :mongo_port
    remove_column :apps, :mongo_host
  end
end
