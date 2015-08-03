class AddDefaultValueToUser < ActiveRecord::Migration
  def change
    change_column :users, :admin_flag,:boolean, default: false
  end
end
