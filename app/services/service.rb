require 'net/http'
require 'net/https'
require 'core_extentions'

class Service < ActiveRecord::Base
  has_friendly_id :title, :use_slug => true
  
  has_many :contracts
  has_many :apps, :through => :contracts
  
  has_many :service_connections
  has_one :service_documentation_page, :dependent => :destroy
 
  accepts_nested_attributes_for :service_documentation_page, :allow_destroy => :true,
        :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  validates_presence_of :title
  validates_presence_of :subtitle
  validates_presence_of :base_url
  validates_presence_of :base_port
  validates_presence_of :service_key
  
  before_validation :ensure_service_key
  
  attr_protected :service_key
    
  scope :available_for_developer, lambda { |dev|
    ba = dev.admin? ? 9999 : dev.beta_access
    return { :conditions => ["beta_level <= ?", ba] }
  }
  
  def ensure_service_key
    return if service_key
    self.service_key = ActiveSupport::SecureRandom.hex(30)
  end
  
  def create_client_for(connection)
    data = "client_key=#{connection.client_key}&client_secret=#{connection.client_secret}"
    path = '/maas/clients'
    
    headers = {
      'Cookie' => "_maas_token=#{self.cookie_value}",
      'Referer' => 'http://maasive.co',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'User-Agent' => 'MaaSiveAPI'
    }
    begin
      response = Net::HTTP.start(self.base_url, self.base_port) do |http|
        response = http.post(path, data, headers)
        response
      end
      return false if response.code != '200'
    rescue EOFError
      connection.errors.add(:base, "Service is unavailable")
      return false
    rescue Errno::ECONNREFUSED
      connection.errors.add(:base, "Service is unavailable")
      return false
    end
    true
  end
  
  def cookie_value
    'TODO'
  end
  
end
