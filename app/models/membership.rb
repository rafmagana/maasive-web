class Membership < ActiveRecord::Base
  belongs_to :developer
  belongs_to :account
  
  validates_presence_of :developer
  validates_presence_of :account
  
  attr_accessor :name
  attr_accessor :email
  
  before_create :ensure_developer
  
  def ensure_developer
    return if developer
    if self.email
      dev = Developer.find_by_email(self.email)
      unless dev
        dev = Developer.invite(:name => name, :email => email)
      end
      self.developer = dev
    end
  end
  
end