class UpdateUser < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.integer :badgeCount
  		t.integer :level
  	end
  end
end
