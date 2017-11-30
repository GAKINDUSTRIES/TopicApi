class AddMatchConversationInstanceTable < ActiveRecord::Migration[5.0]
  def change
    create_table :match_conversation_instances do |t|
      t.references :user              , null: false
      t.references :target            , null: false
      t.references :match_conversation, null: false
      t.boolean    :online,             null: false, default: false
      t.datetime   :last_logout,        null: false
      t.string     :title
      t.timestamps                      null: false
    end

    add_index :match_conversation_instances,
              %i[user_id match_conversation_id],
              unique: true,
              name: :user_conversation_instance_index
  end
end
