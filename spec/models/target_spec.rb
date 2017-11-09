# == Schema Information
#
# Table name: targets
#
#  id         :integer          not null, primary key
#  title      :string           not null
#  lat        :float            not null
#  lng        :float            not null
#  radius     :float            not null
#  topic_id   :integer          not null
#  user_id    :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lonlat     :geography({:srid not null, point, 4326
#  matched    :boolean          default("false")
#
# Indexes
#
#  index_targets_on_lonlat    (lonlat)
#  index_targets_on_matched   (matched)
#  index_targets_on_topic_id  (topic_id)
#  index_targets_on_user_id   (user_id)
#

require 'rails_helper'

describe Target do
  describe 'Associations' do
    it { should belong_to(:user) }
    it { should belong_to(:topic) }
    it { should have_one(:match_conversation_instance).dependent(:destroy) }
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

  describe 'Callbacks' do
    describe '#before_save' do
      describe '#normalize_lonlat' do
        context 'when lng or lat does not change' do
          let(:wrong_target) { build :target, lat: nil }

          it 'raise presence validations before assigns lonlat' do
            wrong_target.save
            expect(wrong_target.errors[:lat]).to eq ["can't be blank"]
          end
        end

        context 'when lng or lat changed' do
          let(:target) { create :target }

          it 'updates lonlat attribute' do
            expect { target.update!(lat: Faker::Number.decimal(2, 6)) }.to change { target.lonlat }
          end
        end
      end
    end

    describe '#after_create' do
      describe '#check_for_match' do
        let(:radius) { 350 }
        let(:topic)  { create :topic }
        %i(user oldest_user newer_user).each { |u| let(u) { create :user } }
        let!(:target) do
          build :target,
                lng: -56.185118,
                lat: -34.906573,
                topic: topic,
                user: user,
                radius: radius
        end
        # 690 mts far from target
        let!(:oldest_nearby_target) do
          create :target,
                 lng: -56.192149,
                 lat: -34.906907,
                 topic: topic,
                 user: oldest_user,
                 radius: radius
        end
        # 690 mts far from target
        let!(:newer_nearby_target) do
          create :target,
                 lng: -56.177232,
                 lat: -34.906642,
                 topic: topic,
                 user: newer_user,
                 radius: radius
        end

        before { target.save }

        it 'creates a new conversation with the same topic of the match' do
          expect(MatchConversation.count).to eq 1
          expect(MatchConversation.first.topic).to eq topic
        end

        it 'creates a match_conversation_instance per matched target' do
          expect(MatchConversationInstance.count).to eq 2
        end

        it 'matches with the nearest nearby target' do
          expect(MatchConversationInstance.pluck(:user_id))
            .to match_array [target.user_id, oldest_nearby_target.user_id]
        end

        it 'assigns both new match_conversation_instances to the new conversation' do
          expect(MatchConversationInstance.pluck(:match_conversation_id).uniq)
            .to match_array [MatchConversation.first.id]
        end
      end
    end
  end

  describe 'Scopes' do
    describe '#same_topic' do
      let(:matched_topic)       { create :topic }
      let(:not_matched_topic)   { create :topic }

      let(:same_topic_targets)  { create_list :target, 3, topic: matched_topic }
      let(:not_matched_targets) { create_list :target, 3, topic: not_matched_topic }

      it 'retrieves matched topics' do
        expect(Target.same_topic(matched_topic)).to match_array same_topic_targets
      end
    end

    # All coordinates were taken from google maps to ensure accuracy on distances
    describe '#matches' do
      before { Target.skip_callback :create, :after, :check_for_match }
      after  { Target.set_callback :create, :after, :check_for_match }

      describe 'Collection matches testing' do
        let(:radius)      { 8000 }
        let(:coordinates) { [-56.184962, -34.906322] }
        let(:topic)       { create :topic }
        let(:target) do
          create :target,
                 lng: coordinates[0],
                 lat: coordinates[1],
                 topic: topic,
                 radius: radius
        end
        let(:matched_coordinates) do
          [
            [-56.185122, -34.906465],
            [-56.190726, -34.905901]
          ]
        end
        let(:faraway_coordinate)  { [-57.190726, -35.905901] }

        let!(:not_matched_target) do
          create :target,
                 lng: faraway_coordinate[0],
                 lat: faraway_coordinate[1],
                 radius: radius,
                 topic: topic
        end
        let!(:matched_targets) do
          targets = []
          matched_coordinates.each do |coordinate|
            targets.push(create :target,
                                lng: coordinate[0],
                                lat: coordinate[1],
                                radius: radius,
                                topic: topic)
          end
          targets
        end

        it 'matches nearby targets' do
          expect(Target.matches(*coordinates, radius, target.id, topic))
            .to match_array matched_targets
        end
      end
      describe 'Accuracy testing (distances between points is +81.xxx)'  do
        let(:radius)      { 40 }
        let(:coordinates) { [-56.185118, -34.906573] }
        let(:topic)       { create :topic }
        let!(:target) do
          create :target,
                 lng: coordinates[0],
                 lat: coordinates[1],
                 topic: topic,
                 radius: radius
        end
        let!(:matched_target) do
          create :target,
                 title: '81.xxx meters far from coordinates',
                 lng: -56.185037,
                 lat: -34.907311,
                 topic: topic,
                 radius: 41
        end

        context 'when distance isn\'t enough (81 mts total)' do
          it 'does not match the target' do
            expect(Target.matches(*coordinates, radius, target.id, topic).count).to eq 0
          end
        end

        context 'when distance is enough (82 mts total)' do
          let(:radius) { 42 }

          it 'matches the target' do
            expect(Target.matches(*coordinates, radius, target.id, topic).count).to eq 1
          end
        end
      end
    end
  end
end
