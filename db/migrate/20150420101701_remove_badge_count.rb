class RemoveBadgeCount < ActiveRecord::Migration
  def change
  	remove_column :users, :badgeCount
  end
end
