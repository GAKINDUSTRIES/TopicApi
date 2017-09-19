json.target do
  json.partial! 'info', target: @target
end

json.match_conversation do
  json.partial! 'api/v1/match_conversations/info', match_conversation: @match_conversation
end if @match_conversation.present?

json.matched_user do
  json.partial! 'api/v1/users/info', user: @match_user
end if @match_user.present?
