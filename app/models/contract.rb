class Contract < ActiveRecord::Base
  belongs_to :app
  belongs_to :service
end
