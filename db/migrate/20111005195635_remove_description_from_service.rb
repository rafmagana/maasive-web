class RemoveDescriptionFromService < ActiveRecord::Migration
  def self.up
    remove_column :services, :description
  end

  def self.down
    add_column :services, :description, :text
  end
end
