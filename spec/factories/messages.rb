# == Schema Information
#
# Table name: messages
#
#  id                    :integer          not null, primary key
#  match_conversation_id :integer
#  user_id               :integer
#  content               :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_messages_on_match_conversation_id  (match_conversation_id)
#  index_messages_on_user_id                (user_id)
#

FactoryGirl.define do
  factory :message do
    match_conversation
    user
    content { Faker::Lorem.sentence }
  end
end
