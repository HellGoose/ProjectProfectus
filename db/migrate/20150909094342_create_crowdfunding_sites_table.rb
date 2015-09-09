class CreateCrowdfundingSitesTable < ActiveRecord::Migration
  def change
    create_table :crowdfunding_sites do |t|
    	t.string :name
    	t.string :logo
    	t.string :link
    	t.string :domain
    	t.timestamps null: false
    end
    add_reference :campaigns, :crowdfunding_site, index: true
  end
end
