class RecreateApps < ActiveRecord::Migration
  def self.up
    drop_table :apps
    create_table :apps do |t|
      t.string  :name
      t.string  :identifier
      t.integer :account_id
      t.string  :encrypted_secret_key
      t.string  :salt
      t.timestamps
    end
    
    OldApp.all.each do |oldapp|
      a = App.new(:name => oldapp.name, :account_id => oldapp.account_id)
      a.identifier = oldapp.id.to_s
      a.save!
    end
  end

  def self.down
    drop_table :apps
    create_table :apps do |t|
      t.string :identifier
      t.integer :account_id
      t.string :name
      t.database_authenticatable
      t.lockable
      t.trackable
      t.rememberable      
      t.encryptable
      t.timestamps
    end
    # OldApp.all.each do |oldapp|
    #   a = App.new(:name => oldapp.name, :account_id => oldapp.account_id)
    #   a.identifier = oldapp.id.to_s
    #   a.save!
    # end
  end
end
