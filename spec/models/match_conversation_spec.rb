# == Schema Information
#
# Table name: match_conversations
#
#  id         :integer          not null, primary key
#  topic_id   :integer          not null
#  icon       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_match_conversations_on_topic_id  (topic_id)
#

require 'rails_helper'

describe MatchConversation do
  describe 'Associations' do
    it { should belong_to(:topic) }
    it { should have_many(:match_conversation_instances).dependent(:destroy) }
    it { should have_many(:users).through(:match_conversation_instances) }
    it { should have_many(:targets).through(:match_conversation_instances) }
  end

  describe 'Validations' do
    it { should validate_presence_of(:topic) }
  end
end
