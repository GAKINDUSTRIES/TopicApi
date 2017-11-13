json.id       message.id
json.content  message.content
json.date     message.created_at.iso8601
json.user do
  json.id     message.user_id
  json.avatar do
    json.url  message.user.avatar.url
  end
end
