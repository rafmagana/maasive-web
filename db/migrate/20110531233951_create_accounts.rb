class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts, :force => true do |t|
      t.string :name
      t.timestamps
    end
    create_table :memberships, :force => true do |t|
      t.integer :developer_id
      t.integer :account_id
      t.timestamps
    end
  end

  def self.down
    drop_table :memberships
    drop_table :accounts
  end
end
