if Rails.env.development?

  # Create admin developer
  admin_dev = Developer.create({:name => "Admin",
                          :email => "admin@domain.com",
                          :has_signed_nda => true,
                          :password => "loremadmin", 
                          :password_confirmation => "loremadmin"})
  admin_dev.admin = true

  admin_dev.save!(false)

  # Create regular developer
  dev = Developer.create({:name => "Ipsum", 
                          :email => "user@domain.com",
                          :has_signed_nda => true,
                          :password => "loremipsum", 
                          :password_confirmation => "loremipsum"})

  dev.save!(false)

end
