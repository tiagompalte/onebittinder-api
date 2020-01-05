json.chats @matches.each do |match|
  json.match_id match.id

  matchee = match.matchee
  matchee = match.matcher if matchee == current_user

  if matchee&.default_photo&.file.attached?
    json.matchee_photo_url polymorphic_url(matchee.default_photo.file)
  else
    json.matchee_photo_url ""
  end

  json.messages match.messages.last(100) do |msg|
    json.id         msg.id
    json.name       msg.user.name
    json.timestamp  msg.created_at
    json.body       msg.body
    json.avatar     polymorphic_url(msg.user.default_photo.file) if msg.user&.default_photo&.file.attached?
    json.me         msg.user == current_user
  end
end