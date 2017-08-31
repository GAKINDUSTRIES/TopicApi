# encoding: utf-8

module Api
  module V1
    class TargetsController < Api::V1::ApiController
      def create
        current_user.targets.create! targets_params
        head :created
      end

      private

      def target_attrs
        %i( title lat lng radius topic_id )
      end

      def targets_params
        params.require(:target).permit(*target_attrs)
      end
    end
  end
end
