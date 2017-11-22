json.match_id        match.id
json.topic_icon      match.icon.url
json.last_message    match.last_message
json.unread_messages match.unread_messages(current_user)
json.user do
  json.partial! 'api/v1/users/brief_info', user: match.another_user(current_user)
end
