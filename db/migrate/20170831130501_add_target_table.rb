class AddTargetTable < ActiveRecord::Migration[5.0]
  def change
    create_table :targets do |t|
      t.string      :title,  null: false
      t.float       :lat,    null: false
      t.float       :lng,    null: false
      t.float       :radius, null: false
      t.references  :topic,  null: false
      t.references  :user,   null: false
      t.timestamps           null: false
    end
  end
end
