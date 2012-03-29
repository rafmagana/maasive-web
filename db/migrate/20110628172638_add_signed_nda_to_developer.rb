class AddSignedNdaToDeveloper < ActiveRecord::Migration
  def self.up
    add_column :developers, :has_signed_nda, :boolean
  end

  def self.down
    remove_column :developers, :has_signed_nda
  end
end
