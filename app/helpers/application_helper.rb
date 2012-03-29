module ApplicationHelper
  
  include EndpointHelper
  
  def selected_app_tab_class(given, key)
    @selected_app_tab == key ? "#{given} selected" : given
  end

  def login_page?
    current_page? :controller => '/invite_requests', :action => :new or current_page? :controller => 'devise/sessions', :action => :new
  end
  
end
