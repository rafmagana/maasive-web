class AddConnectedToServiceConnection < ActiveRecord::Migration
  def self.up
    add_column :service_connections, :connected, :boolean
  end

  def self.down
    remove_column :service_connections, :connected
  end
end
