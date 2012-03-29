class AddBetaLevelToServices < ActiveRecord::Migration
  def self.up
    add_column :services, :beta_level, :integer, :default => 100
    Service.connection.execute("UPDATE services SET beta_level = 100;")
  end

  def self.down
    remove_column :services, :beta_level
  end
end
