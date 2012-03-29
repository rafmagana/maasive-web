require 'net/http'
require 'net/https'
require 'core_extentions'

class ServiceConnection < ActiveRecord::Base
  
  belongs_to :app
  belongs_to :service
  
  validates_presence_of :app
  validates_presence_of :service
  validates_presence_of :client_key
  validates_presence_of :encrypted_client_secret
  
  before_validation     :ensure_client_key, :ensure_client_secret
  validate              :connect!
  
  def connect!
    if self.service.create_client_for(self)
      self.connected = true
    else
      self.connected = false
      self.errors.add_to_base("Could not connected with remote service")
    end
  end
  
  def sign_string(string)
    Digest::SHA1.hexdigest("#{string}#{self.client_key}#{self.client_secret}")
  end
  
  def ensure_client_key
    return unless self.client_key.blank?
    self.client_key = ActiveSupport::SecureRandom.hex(10 + rand(5))
  end

  def ensure_client_secret
    return unless self.encrypted_client_secret.blank?
    self.client_secret = ActiveSupport::SecureRandom.hex(30 + rand(10))
  end
  
  def client_secret
    ::Devise::Encryptors::MaasiveWeb.decrypt self.encrypted_client_secret, self.salt, Devise.pepper
  end

  def client_secret=(key)
    raise "App already has client secret" if self.encrypted_client_secret
    self.encrypted_client_secret = ::Devise::Encryptors::MaasiveWeb.encrypt(key, self.salt, Devise.pepper)
  end
  
  def secure_edit_path
    timestamp = Time.now.to_i
    token     = self.sso_token_with_timestamp(timestamp)
    "http://#{self.service.base_url}:#{self.service.base_port}/maas/clients/#{self.client_key}/edit?sso_token=#{token}&timestamp=#{timestamp}"
  end
  
  def salt
    self['salt'] ||= ActiveSupport::SecureRandom.hex(50)
  end
  
  def run!(command, params={})
    data = params.to_url_params
    path = "/maas/clients/#{self.client_key}/commands/#{command}.json"
    
    headers = {
      'Cookie'       => "_maas_token=#{self.cookie_value}",
      'Referer'      => 'http://maasive.co',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Accepts'      => 'application/json',
      'User-Agent'   => 'MaaSiveAPI'
    }
    
    begin
      response = Net::HTTP.start(self.service.base_url, self.service.base_port) do |http|
        response = http.post(path, data, headers)
        response
      end
    rescue EOFError
      @error = "Service is unavailable"
    rescue Errno::ECONNREFUSED
      @error = "Service is unavailable"
    ensure
      {success: false, error: @error}.to_json
    end

    if !response
      { success: false, error: "Service blew up" }.to_json
    elsif response.code != "200"
      { success: false, error: "Service returned a #{response.code}" }.to_json
    else
      response.body
    end
  end
  
  def cookie_value(options=false)
    hash   = { client_key: self.client_key }
    hash.merge!(options) if options
    json64 = Base64.encode64s(hash.to_json)
    sha    = self.sign_string(json64)
    "#{json64}--#{sha}"
  end
  
  def sso_token_with_timestamp(timestamp)
     sha    = self.sign_string("#{client_key}#{timestamp}")
     "#{sha}"
   end

end
