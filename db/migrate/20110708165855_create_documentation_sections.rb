class CreateDocumentationSections < ActiveRecord::Migration
  def self.up
    create_table :documentation_sections, :force => true do |t|
      t.string :title
      t.integer :priority
      t.timestamps
    end
    add_column :documentation_pages, :documentation_section_id, :integer
    rename_column :documentation_pages, :main_page, :recommended
  end

  def self.down
    remove_column :documentation_pages, :documentation_section_id
    rename_column :documentation_pages, :recommended, :main_page
    drop_table :documentation_sections
  end
end
