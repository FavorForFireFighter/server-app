class AddDefaultValueToUser < ActiveRecord::Migration
  def up
    change_column :users, :admin_flag, :boolean, default: false
  end

  def down
    change_column :users, :admin_flag, :boolean
  end
end
