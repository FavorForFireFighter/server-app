class CreatePrefectures < ActiveRecord::Migration
  def change
    create_table :prefectures do |t|
      t.string :name
      t.st_point :location, srid: 4612, geographic: true

      t.timestamps null: false
    end
  end
end
