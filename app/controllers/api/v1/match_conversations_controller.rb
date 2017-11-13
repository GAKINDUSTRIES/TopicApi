# encoding: utf-8

module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.match_conversations
                   .includes(:targets, match_conversation_instances: :messages).page params[:page]
      end

      def messages
        match_conversation_instance = match_conversation.match_conversation_instances
                                      .find_by(user_id: current_user.id)
        messages = match_conversation_instance.messages.newest.includes(:user)
        messages = messages.page params[:page]
        @messages = messages.reverse
        match_conversation_instance.read_messages
      end

      private

      def match_conversation
        @match_conversation ||= MatchConversation.find(params[:match_conversation_id])
      end
    end
  end
end
