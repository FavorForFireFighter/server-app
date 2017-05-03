class AddStatusToBusStop < ActiveRecord::Migration
  def change
    add_column :bus_stops, :status, :integer
  end
end
