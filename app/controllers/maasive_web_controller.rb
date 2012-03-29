# this is an example of the endpoint a producer would create on their end.
# in this case, we are the producer.
#
# for an example:  https://addons.heroku.com/provider/resources/technical/build/provisioning
class MaasiveWebController < ApplicationController

  def email
    ## TODO:  don't forget the authentication step
    email_template = Email::Template.create!
    result = { :id => email_template.id }
    result.to_json
  end

end
