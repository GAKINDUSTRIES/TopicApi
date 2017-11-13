require 'rails_helper'

class TestConnection
  attr_reader :identifiers, :logger

  def initialize(identifiers_hash = {})
    @identifiers = identifiers_hash.keys
    @logger = ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(StringIO.new))
    identifiers_hash.each do |identifier, value|
      define_singleton_method(identifier) do
        value
      end
    end
  end
end

RSpec.describe 'ChatChannel' do
  let(:user)          { create :user }
  let(:topic)         { create :topic }
  let(:second_topic)  { create :topic }
  let!(:first_target) { create(:target, topic_id: topic.id, user_id: user.id) }
  let!(:second_target) do
    create(:target, topic_id: topic.id, lat: first_target.lat, lng: first_target.lng)
  end
  subject(:channel) { ChatChannel.new(connection, {}) }
  let(:action_cable) { ActionCable.server }
  let(:connection) do
    TestConnection.new(current_user: user,
                       params: { match_conversation_id: first_target.match_conversation.id },
                       server: action_cable)
  end

  let(:data) do
    {
      'action' => 'send_message',
      'match_conversation_id' => first_target.match_conversation.id,
      'content' => 'hello'
    }
  end

  it 'broadcasts a message to the match conversation' do
    expect(action_cable).to receive(:broadcast).once
    channel.perform_action(data)
  end
end
