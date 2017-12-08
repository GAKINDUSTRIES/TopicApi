# == Schema Information
#
# Table name: match_conversation_instances
#
#  id                    :integer          not null, primary key
#  user_id               :integer          not null
#  target_id             :integer          not null
#  match_conversation_id :integer          not null
#  online                :boolean          default("false"), not null
#  last_logout           :datetime         not null
#  title                 :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  unread_messages       :integer          default("0")
#
# Indexes
#
#  index_match_conversation_instances_on_match_conversation_id  (match_conversation_id)
#  index_match_conversation_instances_on_target_id              (target_id)
#  index_match_conversation_instances_on_user_id                (user_id)
#  user_conversation_instance_index                             (user_id,match_conversation_id) UNIQUE
#

class MatchConversationInstance < ApplicationRecord
  belongs_to :match_conversation
  belongs_to :user
  belongs_to :target

  validates :match_conversation, :target, :user, :last_logout, presence: true
  validates :user,
            uniqueness: { scope: :match_conversation, message: 'can\'t be on a conversation twice' }

  before_validation :assign_users_from_target

  def online!
    update!(online: true)
  end

  def offline!
    update!(online: false)
  end

  def increase_unread
    update!(unread_messages: unread_messages + 1)
  end

  def mark_messages_as_read
    update!(unread_messages: 0)
  end

  private

  def assign_users_from_target
    self.user_id = target.user_id
  end
end
