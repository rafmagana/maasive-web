class InviteRequest < ActiveRecord::Base

  validates_presence_of   :email
  validates_uniqueness_of :email, :message => "You've already signed up"

  belongs_to :developer

  scope :waiting, where("developer_id is null")

  def send_request_received_notification
    InviteRequestMailer.request_received_email(self).deliver
  end

end
