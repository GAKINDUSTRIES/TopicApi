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
  has_many :targets, through: :match_conversation_instances
  has_many :users, through: :match_conversation_instances

  validates :topic, presence: true

  def another_user(user)
    users.where.not(id: user.id).first
  end

  def last_message
    match_conversation_instances.first.messages.last
  end

  def user_joined(user)
    match_conversation_instances.find_by(user_id: user.id).online!
  end

  def user_left(user)
    match_conversation_instances.find_by(user_id: user.id).offline!
  end
end
