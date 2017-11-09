json.match_id     match.id
json.user do
  json.partial! 'api/v1/users/brief_info', user: match.another_user(current_user)
end
