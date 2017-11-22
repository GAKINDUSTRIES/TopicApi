require 'rails_helper'

describe 'GET api/v1/match_conversations/{id}/messages', type: :request do
  let!(:user)       { create(:user) }
  let(:second_user) { create(:user) }

  context "when the match conversation doesn't exist" do
    it 'returns not_found' do
      get api_v1_match_conversation_messages_path(match_conversation_id: 1),
          headers: auth_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  context 'with valid params' do
    let(:topic)         { create :topic }
    let!(:first_target) do
      create(:target, topic_id: topic.id, user_id: user.id, lat: -34.907311,
                      lng: -56.185037, radius: 45)
    end
    let!(:second_target) do
      create(:target, topic_id: topic.id, lat: -34.906573, lng: -56.185118, radius: 40)
    end
    let(:match_conversation) { first_target.match_conversation }

    context 'when no messages were sent' do
      it 'returns no messages' do
        get api_v1_match_conversation_messages_path(
          match_conversation_id: match_conversation.id),
            headers: auth_headers, as: :json
        expect(json[:messages].count).to eq 0
      end
    end

    context 'when messages have been sent' do
      before(:each) do
        @first_message, @second_message, @third_message = create_list(
          :message, 3, match_conversation_id: match_conversation.id
        )
      end

      it 'returns three message' do
        get api_v1_match_conversation_messages_path(
          match_conversation_id: first_target.match_conversation.id),
            headers: auth_headers, as: :json
        expect(json[:messages].count).to eq 3
      end

      it 'returns the messages oldest first' do
        get api_v1_match_conversation_messages_path(
          match_conversation_id: match_conversation.id),
            headers: auth_headers, as: :json
        expect(json[:messages][0][:id]).to eq Message.first.id
        expect(json[:messages][1][:id]).to eq Message.second.id
        expect(json[:messages][2][:id]).to eq Message.third.id
      end
    end
  end
end
