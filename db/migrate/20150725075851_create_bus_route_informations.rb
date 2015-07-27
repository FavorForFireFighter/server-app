class CreateBusRouteInformations < ActiveRecord::Migration
  def change
    create_table :bus_route_informations do |t|
      t.integer :bus_type_id
      t.references :bus_operation_company, index: true, foreign_key: true
      t.string :bus_line_name

      t.timestamps null: false
    end
  end
end
