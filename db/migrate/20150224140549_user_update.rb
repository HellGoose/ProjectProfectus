class UserUpdate < ActiveRecord::Migration
  def change
  	change_table :users do |t|
  		t.string :image
  		t.string :location
  	end
  end
end
