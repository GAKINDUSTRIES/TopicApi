json.match_id     match.id
json.topic_icon   match.targets.first.topic.icon
json.last_message match.last_message
json.user do
  json.partial! 'api/v1/users/brief_info', user: match.another_user(current_user)
end
