class AddInviteCodeToInviteRequests < ActiveRecord::Migration
  def self.up
    add_column :invite_requests, :invite_code, :string
  end

  def self.down
    remove_column :invite_requests, :invite_code
  end
end
