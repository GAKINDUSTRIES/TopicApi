class AddTopicTable < ActiveRecord::Migration[5.0]
  def change
    create_table :topics do |t|
      t.string :label, null: false
      t.string :icon
      t.timestamps     null: false
    end
  end
end
