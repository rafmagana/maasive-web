=begin
  https://addons.heroku.com/provider/resources/technical/build/provisioning
=end

class ImplementingServices < ActiveRecord::Migration
  def self.up
    # identify which accounts are also producers
    add_column :accounts, :is_producer, :boolean, :default => false

    create_table :services, :force => true do |t|
      t.string  :title
      t.string  :subtitle
      t.text    :description
      t.integer :account_id
      t.timestamps
    end

    create_table :contracts, :force => true do |t|
      t.integer :app_id
      t.integer :service_id
      t.timestamps
    end

    # for our own email service
    create_table :email_templates, :force => true do |t|
      t.string  :name
      t.string  :from
      t.string  :cc
      t.string  :bcc
      t.string  :subject
      t.string  :content_type
      t.text    :body
      t.integer :account_id
      t.timestamps
    end
  end

  def self.down
    remove_column :accounts, :is_producer
    drop_table    :services
    drop_table    :contracts
    drop_table    :email_templates
  end
end
