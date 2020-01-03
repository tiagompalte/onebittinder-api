class ChatChannel < ApplicationCable::Channel
  def subscribed
    user = User.find_by(authentication_token: params[:token])

    stream_for "chat_channel_#{user.id}"
  end
end