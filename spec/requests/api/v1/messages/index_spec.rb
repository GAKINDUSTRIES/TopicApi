require 'rails_helper'

describe 'GET api/v1/messages', type: :request do
  let(:user)        { create :user }
  let(:second_user) { create :user }
  let(:topic)       { create :topic }
  let!(:first_target) do
    create(:target, topic_id: topic.id, lat: -34.907311, lng: -56.185037, radius: 45,
                    user_id: second_user.id)
  end
  let!(:second_target) do
    create(:target, topic_id: topic.id, user_id: user.id,
                    lat: -34.906573, lng: -56.185118, radius: 40)
  end

  context "when the user doesn't have unread messages" do
    it 'returns success' do
      get api_v1_messages_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns no unread messages' do
      get api_v1_messages_path, headers: auth_headers, as: :json
      expect(json[:count]).to eq 0
    end
  end

  context 'when the user has unread messages' do
    let(:match_conversation) { first_target.match_conversation }

    before(:each) do
      match_conversation.create_message(second_user, 'first_message')
      match_conversation.create_message(second_user, 'second_message')
    end

    it 'returns success' do
      get api_v1_messages_path, headers: auth_headers, as: :json
      expect(response).to have_http_status(:ok)
    end

    it 'returns unread messages count' do
      get api_v1_messages_path, headers: auth_headers, as: :json
      expect(json[:count]).to eq 2
    end
  end
end
