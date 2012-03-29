# Load the rails application
require File.expand_path('../application', __FILE__)
# require 'bluecloth' if Rails.env != "development" && Rails.env != 'test'
require 'core_extentions'

ActionView::Template.register_template_handler :md, lambda {|template| "%q{<div id='markdown'>} + BlueCloth.new(#{template.source.inspect}).to_html + %q{</div>}" }

ActionMailer::Base.default :from => 'MaaSive Support <support@maasive.co>'


# Initialize the rails application
MaasiveWeb::Application.initialize!
