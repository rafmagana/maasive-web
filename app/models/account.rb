class Account < ActiveRecord::Base

  has_many :memberships
  has_many :developers, :through => :memberships
  has_many :apps
  has_many :services

  validates_presence_of :name, :on => :create, :message => "can't be blank"

end
