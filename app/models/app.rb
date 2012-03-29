class App < ActiveRecord::Base
  attr_accessible :name, :account_id

  has_many :service_connections
  has_many :services, :through => :service_connections

  before_validation :ensure_secret_key, :ensure_identifier, :ensure_mongo_host
  before_create     :create_app_db

  validates_presence_of :mongo_host, :mongo_port, :secret_key, :identifier

  belongs_to :account

  scope :latest, lambda { |limit| { :order => "id DESC", :limit => limit } }

  def self.authenticate(cookie_value)
    json64, sha = cookie_value.split("--")
    json        = JSON.parse(Base64.decode64(json64))
    app         = self.find_by_identifier(json["app_identifier"])
    shacheck    = app.sign_string(json64)
    return app if shacheck == sha
    nil
  end

  def self.sign_for_app_id(string, app_id, secret_key)
    Digest::SHA1.hexdigest("#{app_id}#{string}#{secret_key}")
  end

  def self.encryptor_class
    ::Devise::Encryptors::MaasiveWeb
  end

  def ensure_secret_key
    return unless self.encrypted_secret_key.blank?
    self.secret_key = ActiveSupport::SecureRandom.hex(30 + rand(10))
  end

  def ensure_identifier
    return if self.identifier
    self.identifier = ActiveSupport::SecureRandom.hex(10 + rand(5))
  end

  def ensure_mongo_host
    return if self.mongo_port && self.mongo_host
    config = MongoMapper.config[Rails.env]
    self.mongo_host = config["host"]
    self.mongo_port = (config["port"] || 27017)
  end

  def create_app_db
    config = MongoMapper.config[Rails.env]
    
    @connection = Mongo::Connection.new( self.mongo_host, self.mongo_port )

    @admin_db   = @connection.db('admin')
    @admin_db.authenticate(config["username"], config["password"]) if config["password"]

    @db         = @connection.db(self.identifier)
    @db.add_user(self.identifier, self.secret_key)
  end

  def secret_key
    ::Devise::Encryptors::MaasiveWeb.decrypt self.encrypted_secret_key, self.salt, Devise.pepper
  end

  def secret_key=(key)
    raise "App already has secret key" if self.encrypted_secret_key
    self.encrypted_secret_key = ::Devise::Encryptors::MaasiveWeb.encrypt(key, self.salt, Devise.pepper)
  end

  def salt
    self['salt'] ||= ActiveSupport::SecureRandom.hex(50)
  end

  def accounts
    [self.account]
  end

  def sign_string(v)
    Digest::SHA1.hexdigest("#{self.identifier}#{v}#{self.secret_key}")
  end

  def cookie_value(options=false)
    hash   = {app_identifier: self.identifier}
    hash.merge!(options) if options
    json64 = Base64.encode64s(hash.to_json)
    sha    = self.sign_string(json64)
    "#{json64}--#{sha}"
  end

end
