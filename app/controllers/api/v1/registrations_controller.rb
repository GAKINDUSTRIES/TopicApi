# encoding: utf-8

module Api
  module V1
    class RegistrationsController < DeviseTokenAuth::RegistrationsController
      protect_from_forgery with: :exception
      include Concerns::ActAsApiRequest

      def sign_up_params
        params.require(:user).permit(:email, :password, :password_confirmation, :username, :gender)
      end

      def render_create_success
        render json: resource_data
      end
    end
  end
end
