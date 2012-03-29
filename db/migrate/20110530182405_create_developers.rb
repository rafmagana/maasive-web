class CreateDevelopers < ActiveRecord::Migration
  def self.up
    create_table(:developers) do |t|
      t.database_authenticatable :null => false
      t.recoverable
      t.rememberable
      t.trackable
      t.confirmable
      t.token_authenticatable
      t.string  :email
      t.boolean :admin
      t.timestamps
    end
    add_index :developers, :email,                :unique => true
    add_index :developers, :reset_password_token, :unique => true
    add_index :developers, :confirmation_token,   :unique => true
    add_index :developers, :authentication_token, :unique => true
  end

  def self.down
    drop_table :developers
  end
end
