namespace :deploy do

  desc "Switch all app's mongo host"
  task :switch_mongo_hosts => :environment do

    App.connection.execute("UPDATE apps SET mongo_host = 'localhost'")

  end


end
