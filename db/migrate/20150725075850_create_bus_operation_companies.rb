class CreateBusOperationCompanies < ActiveRecord::Migration
  def change
    create_table :bus_operation_companies do |t|
      t.string :name
      t.references :prefecture, index: true, foreign_key: true
      
      t.timestamps null: false
    end
  end
end
