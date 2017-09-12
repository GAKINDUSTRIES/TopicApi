# == Schema Information
#
# Table name: match_conversation_instances
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  target_id             :integer          not null
#  match_conversation_id :integer          not null
#  last_logout           :datetime         not null
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_match_conversation_instances_on_match_conversation_id  (match_conversation_id)
#  index_match_conversation_instances_on_target_id              (target_id)
#  index_match_conversation_instances_on_user_id                (user_id)
#  user_conversation_instance_index                             (user_id,match_conversation_id) UNIQUE
#

require 'rails_helper'

describe MatchConversationInstance do
  describe 'Associations' do
    it { should belong_to(:match_conversation) }
    it { should belong_to(:user) }
    it { should belong_to(:target) }
  end

  describe 'Validations' do
    subject { build :match_conversation_instance, target: create(:target) }

    it { should validate_presence_of(:match_conversation) }
    it { should validate_presence_of(:last_logout) }

    describe 'Validate uniqueness of user scoped to match_conversation with expected message' do
      let(:target)             { create :target }
      let(:match_conversation) { create :match_conversation }
      let!(:match_conversation_instance) do
        create :match_conversation_instance, target: target, match_conversation: match_conversation
      end

      let(:invalid_record) do
        build(:match_conversation_instance, target: target, match_conversation: match_conversation)
      end

      context 'When exists a record with a specific target(user) for a specific conversation' do
        it 'does not create a new record with the same target(user) for the same conversation' do
          expect(invalid_record.valid?).to be_falsy
        end

        it 'returns the correct error message' do
          invalid_record.valid?
          expect(invalid_record.errors[:user][0]).to eq "can't be on a conversation twice"
        end
      end
    end
  end
end
