class AddServicesAlphaToDevelopers < ActiveRecord::Migration
  def self.up
    add_column :developers, :beta_access, :integer, :default => 0
    Developer.connection.execute("UPDATE developers SET beta_access = 0;")
  end

  def self.down
    remove_column :developers, :beta_access
  end
end
