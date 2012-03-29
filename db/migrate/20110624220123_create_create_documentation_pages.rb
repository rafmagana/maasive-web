class CreateCreateDocumentationPages < ActiveRecord::Migration
  def self.up
    create_table :documentation_pages, :force => true do |t|
      t.string  :title
      t.text    :markdown
      t.string  :cached_slug
      t.boolean :main_page
      t.timestamps
    end
  end

  def self.down
    drop_table :documentation_pages
  end
end
