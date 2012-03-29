# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).


# Create developer
dev_attributes = {:name => "Testy Testerton", 
                  :email => "test@test.com", 
                  :password => "testing", 
                  :password_confirmation => "testing"}

dev = Developer.create(dev_attributes)

dev.save!(false)

# Create application
app = dev.accounts.first.apps.create({:name => "Uber App"})

# Create service
service_attributes = {:title => "Epic Email Sender",
                      :subtitle => "Electronic mail is the future... SEND YOURS TODAY.",
                      :description => "The description"}

service = Account.first.services.create(service_attributes)
