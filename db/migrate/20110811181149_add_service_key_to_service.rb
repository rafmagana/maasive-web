class AddServiceKeyToService < ActiveRecord::Migration
  def self.up
    add_column :services, :service_key, :string
    Service.all.each { |s| s.update_attribute(:service_key, ActiveSupport::SecureRandom.hex(30)) }
  end

  def self.down
    remove_column :services, :service_key
  end
end
