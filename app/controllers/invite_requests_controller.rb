class InviteRequestsController < ApplicationController

  def new
    @invite = InviteRequest.new
  end

  def create
    @invite = InviteRequest.new(params[:invite_request])
    if @invite.save
      @invite.send_request_received_notification
    else
      render :new
    end
  end


end
