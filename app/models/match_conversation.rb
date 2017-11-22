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
  mount_uploader :icon, IconUploader

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
    return if match_conversation_instance(user_to_notify).online?
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
    last_time_online = match_conversation_instance(user).last_read
    messages.unread(last_time_online).count
  end

  private

  def match_conversation_instance(user)
    match_conversation_instances.find_by!(user_id: user.id)
  end

  def assign_icon
    self.icon = topic.icon
  end
end
