class CreateBusStops < ActiveRecord::Migration
  def change
    create_table :bus_stops do |t|
      t.string :name
      t.references :prefecture, index: true, foreign_key: true
      t.st_point :location, srid: 4326, geographic: true
      t.datetime :location_updated_at
      t.integer :last_modify_user_id

      t.timestamps null: false
      t.index :location, using: :gist
    end
  end
end
