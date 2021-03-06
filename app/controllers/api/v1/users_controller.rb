# encoding: utf-8

module Api
  module V1
    class UsersController < Api::V1::ApiController
      def show
      end

      def update
        current_user.update!(user_params)
        render :show
      end

      private

      def user_params
        params.require(:user).permit(:username, :first_name, :last_name, :email, :avatar, :gender,
                                     :push_token)
      end
    end
  end
end
