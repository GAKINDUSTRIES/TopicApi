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

class MatchConversation < ApplicationRecord
  mount_base64_uploader :icon, IconUploader

  belongs_to :topic
  has_many :messages
  has_many :match_conversation_instances, dependent: :destroy
  has_many :targets, through: :match_conversation_instances
  has_many :users, through: :match_conversation_instances

  validates :topic, presence: true

  before_create :assign_icon

  def create_message(user, content)
    messages.create!(user_id: user.id, content: content)
    user_to_notify = another_user(user)
    match_instance_user_to_notify = match_conversation_instance(user_to_notify)
    return if match_instance_user_to_notify.online?
    match_instance_user_to_notify.increase_unread
    NotificationsJob.perform_now([user_to_notify.push_token], 'You have received a new message.',
                                 type: 'new_message', match_conversation_id: id
                                )
  end

  def another_user(user)
    users.where.not(id: user.id).first
  end

  def last_message
    messages.last
  end

  def user_joined(user)
    match_conversation_instance(user).online!
  end

  def user_left(user)
    match_conversation_instance(user).offline!
  end

  def unread_messages(user)
    match_conversation_instance(user).unread_messages
  end

  def mark_messages_as_read(user)
    match_conversation_instance(user).mark_messages_as_read
  end

  private

  def match_conversation_instance(user)
    match_conversation_instances.find_by!(user_id: user.id)
  end

  def assign_icon
    self.icon = topic.icon
  end
end
