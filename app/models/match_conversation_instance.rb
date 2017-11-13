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

class MatchConversationInstance < ApplicationRecord
  belongs_to :match_conversation
  belongs_to :user
  belongs_to :target
  has_many :messages

  validates :match_conversation, :target, :user, :last_logout, presence: true
  validates :user,
            uniqueness: { scope: :match_conversation, message: 'can\'t be on a conversation twice' }

  before_validation :assign_users_from_target

  def read_messages
    messages.unread.update_all(read: true)
  end

  def create_message(user, content)
    messages.create!(user_id: user.id, content: content, read: online)
    return if online
    NotificationsJob.perform_now([user.push_token], 'You have received a new message.',
                                 type: 'new_message', match_conversation_id: match_conversation_id
                                )
  end

  def online!
    update!(online: false)
  end

  def offline!
    update!(online: false)
  end

  private

  def assign_users_from_target
    self.user_id = target.user_id
  end
end
