if Rails.env.development?

  # Create developer
  dev = Developer.create({:name => "Admin", 
                          :email => "admin@domain.com",
                          :has_signed_nda => true,
                          :password => "loremipsum", 
                          :password_confirmation => "loremipsum"})

  dev.save!(false)

end
