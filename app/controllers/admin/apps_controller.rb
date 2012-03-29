class Admin::AppsController < Admin::ApplicationController

  def index
    @apps = App.latest(15)
  end

end
