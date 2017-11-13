class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.belongs_to :match_conversation_instance
      t.belongs_to :user
      t.string :content
      t.boolean :read, default: false
      t.timestamps
    end
  end
end
