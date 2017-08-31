require 'rails_helper'

describe 'POST api/v1/targets', type: :request do
  let(:user)           { create :user }
  let(:topic)          { create :topic }
  let(:target_created) { Target.last }

  let(:params) do
    { target: attributes_for(:target).merge(topic_id: topic.id) }
  end

  context 'with valid params' do
    it 'returns success' do
      post api_v1_targets_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:created)
    end

    it 'creates the target' do
      expect do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
      end.to change(Target, :count).by(1)
    end

    it 'assigns the correct user' do
      post api_v1_targets_path, params: params, headers: auth_headers, as: :json
      expect(target_created.user_id).to eq user.id
    end

    it 'assigns the correct topic' do
      post api_v1_targets_path, params: params, headers: auth_headers, as: :json
      expect(target_created.topic_id).to eq topic.id
    end
  end

  context 'with invalid params' do
    before(:each) { params[:target][:topic_id] = nil }

    it 'returns bad request' do
      post api_v1_targets_path, params: params, headers: auth_headers, as: :json
      expect(response).to have_http_status(:bad_request)
    end
  end
end
