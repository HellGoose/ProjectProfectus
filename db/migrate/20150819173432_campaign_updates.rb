class CampaignUpdates < ActiveRecord::Migration
  def change
  	change_table :campaigns do |t|
		t.text :content
		t.integer :pledged
		t.integer :goal
		t.string :author
		t.integer :backers
		t.date :end_time
	end
  end
end
