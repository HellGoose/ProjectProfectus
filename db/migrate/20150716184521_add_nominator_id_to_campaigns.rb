class AddNominatorIdToCampaigns < ActiveRecord::Migration
  def change
  	add_column :campaigns, :nominator_id, :integer
  	add_foreign_key :campaigns, :users, column: :nominator_id
  	Campaign.all.each do |c|
  		c.nominator_id = c.user_id
  		c.save
  	end
  end
end
