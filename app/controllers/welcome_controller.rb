class WelcomeController < ApplicationController

  def index
    path = current_developer ? dashboard_path : new_invite_request_path
    redirect_to path and return
  end

  def nda
  end

end
