# encoding: utf-8

module Api
  module V1
    class TargetsController < Api::V1::ApiController
      helper_method :target

      def create
        @target = current_user.targets.create! targets_params
        @match_conversation = @target.match_conversation
        @match_user = @match_conversation.try(:another_party, current_user)
      end

      def index
        @targets = current_user.targets.page params[:page]
      end

      def destroy
        target.destroy!
        head :ok
      end

      private

      def target
        @target ||= current_user.targets.find params[:id]
      end

      def target_attrs
        %i( title lat lng radius topic_id )
      end

      def targets_params
        params.require(:target).permit(*target_attrs)
      end
    end
  end
end
