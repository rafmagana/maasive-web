class CreateServiceConnections < ActiveRecord::Migration
  def self.up
    create_table :service_connections do |t|
      t.integer :app_id
      t.integer :service_id
      
      t.string :client_key
      t.string :encrypted_client_secret
      
      t.string :salt
    
      t.timestamps
    end
  end

  def self.down
    drop_table :service_connections
  end
end
