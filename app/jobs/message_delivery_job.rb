class MessageDeliveryJob < ApplicationJob
  queue_as :default

  def perform(message)
    send_notification(message.match.matcher, message) unless message.match.matcher == message.user
    send_notification(message.match.matchee, message) unless message.match.matchee == message.user
  end

  private

  def send_notification(user, message)
    ChatChannel.broadcast_to "chat_channel_#{user.id}", build_message(message, user)
  end

  def build_message(message, receiver)
    matchee = message.match.matchee
    matchee = message.match.matcher if matchee == receiver

    msg = {
        match_id: message.match.id,
        messages: [{
                       name: message.user.name,
                       timestamp: message.created_at,
                       body: message.body
                   }]
    }

    msg[:messages][0][:avatar] = Rails.application.routes.url_helpers.rails_blob_path(message.user.default_photo.file, only_path: true) if message.user.default_photo.file.attached?
    msg[:messages][0][:me]     = message.user == receiver
    msg[:messages][0][:color]  = message.user == receiver ? 'green' : 'blue'

    if matchee&.default_photo&.file.attached?
      msg[:matchee_photo_url] = Rails.application.routes.url_helpers.rails_blob_path(matchee.default_photo.file, only_path: true) if matchee.default_photo.file.attached?
    else
      msg[:matchee_photo_url] = ""
    end

    msg
  end
end
