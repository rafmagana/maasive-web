class Admin::ApplicationController < ApplicationController
  
  prepend_before_filter :require_admin
  
end