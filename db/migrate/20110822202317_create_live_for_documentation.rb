class CreateLiveForDocumentation < ActiveRecord::Migration
  def self.up
    add_column :documentation_pages, :live, :boolean
    DocumentationPage.connection.execute("UPDATE documentation_pages SET live = 1;")
  end

  def self.down
    remove_column :documentation_pages, :live
  end
end
