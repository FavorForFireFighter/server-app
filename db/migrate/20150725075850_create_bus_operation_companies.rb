class CreateBusOperationCompanies < ActiveRecord::Migration
  def change
    create_table :bus_operation_companies do |t|
      t.string :name
      
      t.timestamps null: false
    end
  end
end
