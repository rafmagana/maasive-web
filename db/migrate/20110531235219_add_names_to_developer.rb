class AddNamesToDeveloper < ActiveRecord::Migration
  def self.up
    add_column :developers, :name, :string
  end

  def self.down
    remove_column :developers, :name
  end
end
