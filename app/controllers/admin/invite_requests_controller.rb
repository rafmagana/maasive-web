class Admin::InviteRequestsController < Admin::ApplicationController

  def index
    @invite_requests = InviteRequest.waiting.order('invite_code DESC')
  end

  def invite
    @invite_request = InviteRequest.find(params[:id])
    dev = Developer.invite!(:email => @invite_request.email)
    if @invite_request.update_attribute(:developer_id, dev.id)
      flash[:notice] = " #{@invite_request.email} has been invited"
      redirect_to admin_invite_requests_path
    else
      render :text => "Error could not invite person"
    end
  end

end
