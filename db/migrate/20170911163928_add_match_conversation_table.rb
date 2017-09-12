class AddMatchConversationTable < ActiveRecord::Migration[5.0]
  def change
    create_table :match_conversations do |t|
      t.references :topic,     null: false
      t.timestamps             null: false
    end
  end
end
