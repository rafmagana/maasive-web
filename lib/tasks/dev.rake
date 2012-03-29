namespace :dev do
  namespace :db do
    task :redo do
      `rake db:drop && rake db:create && rake db:migrate && rake db:seed`
    end
  end

  namespace :fix do
    desc "ApiTables didn't have updated at"
    task :updated_at => :environment do
      puts "\033[033mSaving: #{ApiTable.count} \033[0m"
      ApiTable.all.each do |at|
        # note this doesn't actually set the updated at to created at, but changes it so it will be saved
        print (at.update_attribute(:updated_at, at.created_at) ? "\033[032m.\033[37m" : "\033[05m!\033[37m" )
      end
      puts "\n\033[032mCompleted \033[0m"
    end
  end
end

# rake dev:apps:switch_encryption
namespace :dev do

  namespace :apps do
    
    desc "Remove apps DB"
    task :clear => :environment do
      raise "use $ APP_ID='123123123' rake dev:apps:clear " unless ENV['APP_ID']
      
      app = App.find_by_identifier(ENV['APP_ID'])
      
      raise "Aint no app with that ID" unless app
      
      puts  "\n\n\033[033m--------------------------------------------"
      puts  " \033[5m           AWESOMENESS INITIALIZED \033[0m"
      puts  "\033[033m---------------------------------------------\033[0m \n\n"
      
      puts "Running in #{Rails.env} mode"
      
      config = MongoMapper.config[Rails.env]
      
      @connection = Mongo::Connection.new( app.mongo_host, app.mongo_port )
      @admin_db   = @connection.db('admin')
      @admin_db.authenticate(config["username"], config["password"]) if config["password"]
      
      puts "Removing application database"
      
      @connection.drop_database(app.identifier)
      
      puts "\033[32m Deleted! \033[37m"
      
      puts "Removing ApiTables database"
      
      ApiTable.where(:app_id => app.identifier).each do |a|
        a.destroy
      end
      
      puts "\033[32m Deleted! \033[37m"
      
      app.create_app_db
      
      puts "\033[32m New DB Created! \033[37m"

      puts "All done"
    end
    
    desc "Re-save all apps"
    task :resave => :environment do
      App.all.each { |a| a.save; print "\033[32m :-) \033[37m" }
    end
    
    
    desc "Switch Encryption"
     task :switch_encryption => :environment do
       App.all.each do |a|
         secret = Devise::Encryptors::MaasiveWeb.decrypt_old(a.encrypted_secret_key, a.salt, Devise.pepper)
         a.update_attribute(:encrypted_secret_key, Devise::Encryptors::MaasiveWeb.encrypt(secret, a.salt, Devise.pepper))
       end
     end
     
     desc "Switch Encryption BACK"
      task :switch_encryption_back => :environment do
        App.all.each do |a|
          secret = Devise::Encryptors::MaasiveWeb.decrypt(a.encrypted_secret_key, a.salt, Devise.pepper)
          a.update_attribute(:encrypted_secret_key, Devise::Encryptors::MaasiveWeb.encrypt_old(secret, a.salt, Devise.pepper))
        end
      end
  end
  
  # rake dev:service_connections:switch_encryption  
  namespace :service_connections do
    desc "Switch Encryption"
     task :switch_encryption => :environment do
       ServiceConnection.all.each do |a|
         secret = Devise::Encryptors::MaasiveWeb.decrypt_old(a.encrypted_client_secret, a.salt, Devise.pepper)
         a.update_attribute(:encrypted_client_secret, Devise::Encryptors::MaasiveWeb.encrypt(secret, a.salt, Devise.pepper))
       end
     end
     
     desc "Switch Encryption BACK"
      task :switch_encryption_back => :environment do
        ServiceConnection.all.each do |a|
          secret = Devise::Encryptors::MaasiveWeb.decrypt(a.encrypted_client_secret, a.salt, Devise.pepper)
          a.update_attribute(:encrypted_client_secret, Devise::Encryptors::MaasiveWeb.encrypt_old(secret, a.salt, Devise.pepper))
        end
      end
  end
end
