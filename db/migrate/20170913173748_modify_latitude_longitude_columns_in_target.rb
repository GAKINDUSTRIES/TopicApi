class ModifyLatitudeLongitudeColumnsInTarget < ActiveRecord::Migration[5.0]
  def change
    add_column :targets, :lonlat, :st_point, geographic: true, null: false
    add_index  :targets, :lonlat, using: :gist
  end
end
