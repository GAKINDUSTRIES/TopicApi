class AddUnmatchedColumnToTarget < ActiveRecord::Migration[5.0]
  def change
    add_column :targets, :matched, :boolean, default: false
    add_index  :targets, :matched
  end
end
