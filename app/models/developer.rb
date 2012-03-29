require 'beta_access'

class Developer < ActiveRecord::Base
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :has_signed_nda
  
  has_many :memberships
  has_many :accounts, :through => :memberships
  has_one :invite_request
  
  before_create :create_default_account
  
  validate :check_nda
  
  validates_presence_of :name

  def check_nda
    self.errors.add(:has_signed_nda, "Acceptance of the NDA is required for registration.") if !self.has_signed_nda? && !self.password.blank?
  end

  def apps
    App.where(["account_id IN (?)", self.accounts.map(&:id)])
  end
  
  def create_default_account
    name = self.name || self.email
    self.accounts.build(:name => "#{name}")
  end
  
  def has_access_to_beta_level(level)
    return true if self.admin
    self.beta_access >= level
  end
  
end
