# encoding: utf-8

module Api
  module V1
    class MatchConversationsController < Api::V1::ApiController
      def index
        @matches = current_user.match_conversations.includes(:targets).page params[:page]
      end
    end
  end
end
