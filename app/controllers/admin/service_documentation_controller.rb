class Admin::ServiceDocumentationController < Admin::ApplicationController

  def show
    @page = ServiceDocumentationPage.find(params[:id])
  end

end
