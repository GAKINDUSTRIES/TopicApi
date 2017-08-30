json.id         user.id
json.email      user.email
json.first_name user.first_name
json.last_name  user.last_name
json.full_name  user.full_name
json.username   user.username
json.gender     user.gender
json.avatar do
  json.original_url    user.avatar.url
  json.normal_url      user.avatar.url(:normal)
  json.small_thumb_url user.avatar.url(:small_thumb)
end
