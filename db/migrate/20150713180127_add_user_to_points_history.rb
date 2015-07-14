class AddUserToPointsHistory < ActiveRecord::Migration
  def change
    add_reference :points_histories, :user, index: true
    add_foreign_key :points_histories, :users
  end
end
