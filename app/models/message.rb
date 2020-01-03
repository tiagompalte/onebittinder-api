class Message < ApplicationRecord
  belongs_to :match
  belongs_to :user

  after_create :notify_users

  private

  def notify_users
    MessageDeliveryJob.perform_now(self)
  end
end