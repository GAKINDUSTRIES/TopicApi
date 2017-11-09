require 'rails_helper'

describe 'POST api/v1/targets', type: :request do
  let(:user)           { create :user }
  let(:topic)          { create :topic }
  let(:radius)         { 40 }
  let(:coordinates)    { [34.901112, 56.164532] }
  let(:target_created) { Target.last }

  let(:params) do
    {
      target: {
        title: 'New target title',
        topic_id: topic.id,
        lng: coordinates[0],
        lat: coordinates[1],
        radius: radius
      }
    }
  end

  context 'with valid params' do
    context 'when matches a target' do
      let(:matched_target_user) { create :user }
      let!(:matched_target) do
        create :target,
               title: '81.xxx meters far from coordinates',
               lng: 34.901102,
               lat: 56.164522,
               topic: topic,
               user: matched_target_user,
               radius: 45
      end
      it 'returns success' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'returns the correct format' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(response).to match_response_schema('targets/create', strict: true)
      end

      it 'creates the target' do
        expect do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        end.to change(Target, :count).by(1)
      end

      it 'creates a new match conversation and match conversation instances' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(MatchConversation.count).to eq 1
        expect(MatchConversationInstance.count).to eq 2
      end

      it 'returns the owner of the matched target' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(json[:matched_user][:id]).to eq matched_target_user.id
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

    context 'when does not match a target' do
      it 'returns success' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(response).to have_http_status(:success)
      end

      it 'does not return a match conversation' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(json).not_to include(:match_conversation)
      end

      it 'does not return a matched user' do
        post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        expect(json).not_to include(:matched_user)
      end
    end

    context 'when a match is find' do
      let!(:first_target) do
        create(:target, topic_id: params[:target][:topic_id],
                        lat: params[:target][:lat],
                        lng: params[:target][:lng])
      end

      it 'creates the match conversation' do
        expect do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        end.to change(MatchConversation, :count).by(1)
      end

      it 'creates the match conversation instances' do
        expect do
          post api_v1_targets_path, params: params, headers: auth_headers, as: :json
        end.to change(MatchConversationInstance, :count).by(2)
      end
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
