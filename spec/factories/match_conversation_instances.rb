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
#  online                :boolean          default("false")
#
# Indexes
#
#  index_match_conversation_instances_on_match_conversation_id  (match_conversation_id)
#  index_match_conversation_instances_on_target_id              (target_id)
#  index_match_conversation_instances_on_user_id                (user_id)
#  user_conversation_instance_index                             (user_id,match_conversation_id) UNIQUE
#

FactoryGirl.define do
  factory :match_conversation_instance do
    match_conversation
    target
    user
    last_logout { Faker::Date.backward(14) }
    title       { Faker::Name.title }
  end
end
