class CreateServiceDocumentationPages < ActiveRecord::Migration
  def self.up
    create_table :service_documentation_pages do |t|
      t.string :title
      t.text :markdown 
      t.integer :service_id

      t.timestamps
    end
  end

  def self.down
    drop_table :service_documentation_pages
  end
end
