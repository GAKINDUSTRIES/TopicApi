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

class Message < ApplicationRecord
  belongs_to :match_conversation
  belongs_to :user

  validates :content, presence: true

  scope :newest, -> { order(id: :desc) }
  scope :unread, -> (last_time_online) { where('created_at > ?', last_time_online) }
end
