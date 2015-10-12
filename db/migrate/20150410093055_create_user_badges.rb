class CreateUserBadges < ActiveRecord::Migration
  def change
    create_table :user_badges do |t|
    	t.belongs_to :user 	,index: true, null: false
    	t.belongs_to :badge ,index: true,  null: false
    	t.integer :timesAchieved
      t.timestamps null: false
    end
  end
end
