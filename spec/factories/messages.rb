# == Schema Information
#
# Table name: messages
#
#  id                             :integer          not null, primary key
#  match_conversation_instance_id :integer
#  user_id                        :integer
#  content                        :string
#  read                           :boolean          default("false")
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#
# Indexes
#
#  index_messages_on_match_conversation_instance_id  (match_conversation_instance_id)
#  index_messages_on_user_id                         (user_id)
#

FactoryGirl.define do
  factory :message do
    match_conversation_instance
    user
    content { Faker::Lorem.sentence }
  end
end
