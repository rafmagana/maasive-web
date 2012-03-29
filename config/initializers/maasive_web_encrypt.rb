module Devise
  module Encryptors
    class MaasiveWeb < Base
      
      def self.cipher(mode, salt, pepper)
        @cipher = OpenSSL::Cipher::Cipher.new('aes-128-cbc')
        if mode
          @cipher.encrypt
        else
          @cipher.decrypt
        end
  
        key = Digest::SHA1.hexdigest(salt + pepper)

        @cipher.key = key
        @cipher.iv  = '0b16198be3f2e812'
        @cipher
      end
      
      def self.encypter_key(salt, pepper)
        EzCrypto::Key.with_password salt, pepper
      end
      
      def self.digest(password, stretches, salt, pepper)
        self.encrypt(password, salt, pepper)
      end
      
      def self.encrypt_old(password, salt, pepper)
        Base64.strict_encode64(self.encypter_key(salt, pepper).encrypt(password))
      end
      
      def self.decrypt_old(password, salt, pepper)
        self.encypter_key(salt, pepper).decrypt(Base64.strict_decode64(password))
      end
      
      def self.encrypt(password, salt, pepper)
        cipher = self.cipher(true, salt, pepper)
        encrypted = cipher.update(password)
        Base64.strict_encode64("#{encrypted}#{cipher.final}")
      end
      
      def self.decrypt(encrypted64, salt, pepper)
        encrypted = Base64.strict_decode64(encrypted64)
        cipher = self.cipher(false, salt, pepper)
        password = cipher.update(encrypted)
        "#{password}#{cipher.final}"
      end
      
    end
  end
end
