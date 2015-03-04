class AddDonationAmountToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :donationAmount, :float
  end
end
