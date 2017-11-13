class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_for match_conversation
    match_conversation.user_joined(current_user)
  end

  def unsubscribed
    match_conversation.user_left(current_user)
  end

  def send_message(data)
    content = data['content']
    match_conversation = MatchConversation.find(data['match_conversation_id'])
    create_messages(match_conversation, content)
    self.class.broadcast_to match_conversation, message_params(content)
  end

  private

  def match_conversation
    MatchConversation.find(params[:match_conversation_id])
  end

  def message_params(content)
    { content: content,
      action: 'new_message',
      user: {
        avatar: {
          url: current_user.avatar.url
        }
      },
      user_id: current_user.id,
      date: Time.zone.now.iso8601 }
  end

  def create_messages(match_conversation, content)
    match_conversation.match_conversation_instances.each do |instance|
      instance.create_message(current_user, content)
    end
  end
end
