class AddUnreadMessagesCountToMatchConversationInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :match_conversation_instances, :unread_messages, :integer, default: 0
  end
end
