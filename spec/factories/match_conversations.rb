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

FactoryGirl.define do
  factory :match_conversation do
    topic
  end
end
