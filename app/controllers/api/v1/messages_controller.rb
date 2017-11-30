# encoding: utf-8

module Api
  module V1
    class MessagesController < Api::V1::ApiController
      def index
        @unread_messages_count = current_user.unread_messages_count
      end
    end
  end
end
