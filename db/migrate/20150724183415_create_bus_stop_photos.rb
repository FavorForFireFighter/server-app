class CreateBusStopPhotos < ActiveRecord::Migration
  def change
    create_table :bus_stop_photos do |t|
      t.attachment :photo
      t.references :bus_stop, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :title

      t.timestamps null: false
    end
  end
end
