class UpdatesToProject < ActiveRecord::Migration
  def change
  	change_table :projects do |t|
  		t.remove :flagged
  		t.integer :flagCount
  		t.integer :badgeCount
  	end
  end
end
