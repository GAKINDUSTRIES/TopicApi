# == Schema Information
#
# Table name: match_conversations
#
#  id         :integer          not null, primary key
#  topic_id   :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_match_conversations_on_topic_id  (topic_id)
#

class MatchConversation < ApplicationRecord
  belongs_to :topic

  has_many :match_conversation_instances, dependent: :destroy
  has_many :users, through: :match_conversation_instances
  has_many :targets, through: :match_conversation_instances

  validates :topic, presence: true

  def another_party(user)
    users.where.not(id: user.id).first
  end
end
