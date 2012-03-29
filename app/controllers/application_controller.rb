class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_app, :app_contraints

  def load_accounts
    @accounts = current_developer.accounts
  end

  def current_app
    return @current_app if @current_app
    if current_developer
      if current_developer.admin?
        load_current_app_for_admin
      else
        load_current_app_for_developer
      end
    else
      load_current_app_form_session
    end
  end
  
  def app_contraints
    session[:app_contraints] || {}
  end
  
  def require_developer
    authenticate_developer!
  end
  
  def require_app
    unless current_app
      throw(:warden)
    end
  end
  
  def require_admin
    unless current_developer.try(:admin)
      throw(:warden)
    end
  end
  
  def require_developer_or_app
    throw(:warden) if !current_app && !current_developer
  end
  
  def save_analytics
    RequestAnalytic.create_for_app_from_env_with(params[:app_id], request.env, params)
  end
  
  protected
  
  def load_current_app_for_developer
    return nil unless params[:app_id]
    @current_app = current_developer.apps.find_by_identifier(params[:app_id])
  end
  
  def load_current_app_for_admin
    return nil unless params[:app_id]
    @current_app = App.find_by_identifier(params[:app_id])
  end
  
  def load_current_app_form_session
    puts cookies["_app_token"].inspect
    @current_app = App.authenticate(cookies["_app_token"])
  rescue StandardError => e
    puts "APP TOKEN ERROR: #{e.class} #{e.message}"
    @current_app = nil
  end
  
  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(Developer)
        resource.admin? ? admin_invite_requests_path : what_is_maasive_path
      else
        welcome_index_path(resource)
      end
  end
end
