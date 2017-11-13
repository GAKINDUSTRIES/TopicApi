class AddOnlineToMatchConversationInstance < ActiveRecord::Migration[5.0]
  def change
    add_column :match_conversation_instances, :online, :boolean, default: false
  end
end
