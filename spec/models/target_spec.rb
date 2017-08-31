require 'rails_helper'

describe Target do
  describe 'Associations' do
    it { should belong_to(:user)  }
    it { should belong_to(:topic)  }
  end

  describe 'Validations' do
    subject { build :target, user: create(:user) }

    it { should validate_presence_of(:topic) }
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:lat) }
    it { should validate_presence_of(:lng) }
    it { should validate_presence_of(:radius) }

    describe '#amount_of_targets' do
      let!(:user)  { create :user }
      let(:target) { build :target, user: user }

      context 'when user does NOT reach the limit amount of targets' do
        it 'creates a new target' do
          expect(target).to be_valid
        end
      end

      context 'when user reaches the limit amount of targets' do
        it 'does NOT create a new target' do
          create_list :target, User::TARGET_AMOUNT_LIMIT, user: user

          expect(target).not_to be_valid
        end
      end
    end
  end
end
