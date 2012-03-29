require 'net/http'
require 'net/https'

class MongoConnection

  def self.base_url
    "mongolab.com"
  end

  def self.path
    "/api/1/login/partner_sso"
  end

  def self.register
    timestamp = Time.now.to_i
    token = Digest::SHA1.hexdigest("elc:zxW1s41hw7pqs218ql5aT8Bh+jCntTCw:#{timestamp}")
    #{self.base_url}#{self.path}?username=elc&timestamp=#{timestamp}&token=#{token}&apiKey=4de5d51a8d4587af0ffdd368"

    headers = {
      'Referer'      => 'http://maasiveapi.co',
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Accepts'      => 'application/json',
      'User-Agent'   => 'MaaSiveAPI'
    }

    data = {
      'username' => 'elc',
      'timestamp' => timestamp.to_s,
      'token'     => token,
      'apiKey'    => '4de5d51a8d4587af0ffdd368'
    }

    begin
      http = Net::HTTP.new(self.base_url, "443")
      http.use_ssl = true
      response = http.start { |http|
        response = http.get(self.path, data, [])
        puts response.inspect
        response
      }
    rescue EOFError
      @errors = ["Service is unavailable"]
    rescue Errno::ECONNREFUSED
      @errors = ["Service is unavailable"]
    ensure
      {success: false, errors: @errors}.to_json
    end

    if response.code == "200"
      response.body
    else
      {success: false, errors: ["Mongo returned a #{response.code}"]}.to_json
    end
  end

  # Action: POST /api/1/partners/elc/accounts/statuskit/databases
  # Input:  { "name": "sociallist",
  #           "plan": "free",
  #           "username": "user",
  #           "password": "1234" }
  # Output: { "name": "statuskit_sociallist",
  #            "uri": "mongodb://elc:1234@dbh42.mongolab.com:6001/statuskit_sociallist_logs" }
  #
  def self.database_create
  end

  # Action: DELETE /api/1/partners/:name/accounts/:name/databases/:name
  def self.database_delete
  end
end
