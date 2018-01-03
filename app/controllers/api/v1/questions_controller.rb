module Api
  module V1
    class QuestionsController < Api::V1::ApiController
      skip_before_action :authenticate_user!

      def create
        Question.create!(question_params)
        head :ok
      end

      private

      def question_params
        params.require(:question).permit(:body, :email)
      end
    end
  end
end
