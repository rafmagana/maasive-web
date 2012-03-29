class AddingInvitedCheck < ActiveRecord::Migration
  def self.up
    add_column :invite_requests, :developer_id, :integer
  end

  def self.down
    remove_column :invite_requests, :developer_id
  end
end
