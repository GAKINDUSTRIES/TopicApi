require 'rails_helper'

describe 'POST api/v1/questions', type: :request do
  let(:params) do
    {
      question: {
        email: Faker::Internet.email,
        body: Faker::Lorem.paragraph
      }
    }
  end

  context 'with valid params' do
    it 'returns success' do
      post api_v1_questions_path, params: params, as: :json
      expect(response).to have_http_status(:success)
    end

    it 'creates the question' do
      expect do
        post api_v1_questions_path, params: params, as: :json
      end.to change(Question, :count).by(1)
    end
  end

  context 'with invalid params' do
    before(:each) { params[:question][:body] = nil }

    it 'returns bad request' do
      post api_v1_questions_path, params: params, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
