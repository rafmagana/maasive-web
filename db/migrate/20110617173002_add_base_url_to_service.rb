class AddBaseUrlToService < ActiveRecord::Migration
  def self.up
    add_column :services, :base_url, :string
    add_column :services, :base_port, :integer
  end

  def self.down
    remove_column :services, :base_port
    remove_column :services, :base_url
  end
end
