class DropPointsHistory < ActiveRecord::Migration
  def change
    drop_table :points_histories
  end
end
