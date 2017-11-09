require 'rails_helper'

describe 'GET api/v1/match_conversations', type: :request do
  let(:user)          { create :user }
  let(:topic)         { create :topic }
  let(:second_topic)  { create :topic }
  let!(:first_target) { create(:target, topic_id: topic.id, user_id: user.id) }
  let!(:second_target) do
    create(:target, topic_id: topic.id, lat: first_target.lat, lng: first_target.lng)
  end
  let!(:third_target) { create(:target, topic_id: second_topic.id, user_id: user.id) }
  let!(:fourth) do
    create(:target, topic_id: second_topic.id, lat: third_target.lat, lng: third_target.lng)
  end

  it 'returns success' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:ok)
  end

  it 'returns matched targets conversations' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(json[:matches].count).to eq 2
  end
end
