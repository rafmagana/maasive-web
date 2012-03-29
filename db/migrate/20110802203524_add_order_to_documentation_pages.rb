class AddOrderToDocumentationPages < ActiveRecord::Migration
  def self.up
    add_column  :documentation_pages, :position, :integer
  end

  def self.down
    drop_column :documentation_pages, :position
  end
end
