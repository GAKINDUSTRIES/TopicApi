require 'rails_helper'

describe 'GET api/v1/match_conversations', type: :request do
  let(:user)          { create :user }
  let(:second_user)   { create :user }
  let(:topic)         { create :topic }
  let(:second_topic)  { create :topic }
  let!(:first_target) do
    create(:target, topic_id: topic.id, lat: -34.907311, lng: -56.185037, radius: 45,
                    user_id: second_user.id)
  end
  let!(:second_target) do
    create(:target, topic_id: topic.id, user_id: user.id,
                    lat: -34.906573, lng: -56.185118, radius: 40)
  end
  let!(:third_target) do
    create(:target, topic_id: second_topic.id, user_id: user.id, lat: -34.907311,
                    lng: -56.185037, radius: 45)
  end
  let!(:fourth) do
    create(:target, topic_id: second_topic.id, lat: -34.906573, lng: -56.185118, radius: 40,
                    user_id: second_user.id)
  end
  let!(:first_message) do
    create(:message, match_conversation_id: second_target.match_conversation.id,
                     created_at: Faker::Date.backward(1))
  end
  let(:match_conversation) { second_target.match_conversation }
  before(:each) do
    match_conversation.create_message(second_user, 'first_message')
    match_conversation.create_message(second_user, 'second_message')
  end

  it 'returns success' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(response).to have_http_status(:ok)
  end

  it 'returns matched targets conversations' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(json[:matches].count).to eq 2
  end

  it 'returns the last message of the conversation' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(json[:matches][0][:last_message]).to eq 'second_message'
  end

  it 'returns the amount of unread messages on each conversation' do
    get api_v1_match_conversations_path, headers: auth_headers, as: :json
    expect(json[:matches][0][:unread_messages]).to eq 2
    expect(json[:matches][1][:unread_messages]).to eq 0
  end
end
