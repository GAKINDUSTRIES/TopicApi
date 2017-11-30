# encoding: utf-8

module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.match_conversations
                   .includes(:match_conversation_instances, :messages).page params[:page]
      end

      def messages
        messages = match_conversation.messages.newest.includes(:user)
        messages = messages.page params[:page]
        @messages = messages.reverse
        match_conversation.mark_messages_as_read(current_user)
      end

      private

      def match_conversation
        @match_conversation ||= MatchConversation.find(params[:match_conversation_id])
      end
    end
  end
end
