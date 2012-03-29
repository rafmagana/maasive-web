class DevelopersController < Devise::RegistrationsController
  
  skip_before_filter :require_no_authentication, :only => [:new, :create]
  before_filter :admin_required, :only => [:new, :create]
  add_breadcrumb "Dashboard", :root_path
  
  def new
    return redirect_to '/' unless current_developer
    super
  end
  
  def admin_required
    unless current_developer.admin? 

       render :text => "Not Found 404", :status => 404
      
    end
  end
  
end

