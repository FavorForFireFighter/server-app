class AddSoftDestroyedAtToBusStop < ActiveRecord::Migration
  def change
    add_column :bus_stops, :soft_destroyed_at, :datetime
    add_index :bus_stops, :soft_destroyed_at
  end
end
