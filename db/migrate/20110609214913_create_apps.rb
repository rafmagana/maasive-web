class CreateApps < ActiveRecord::Migration
  def self.up
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
    #   App.create(:identifier => oldapp.id.to_s, :name => oldapp.name, :account_id => oldapp.account_id)
    # end
    
  end

  def self.down
    drop_table :apps
  end
end
