json.id         user.id
json.full_name  user.full_name
json.avatar do
  json.original_url    user.avatar.url
  json.normal_url      user.avatar.url(:normal)
  json.small_thumb_url user.avatar.url(:small_thumb)
end
