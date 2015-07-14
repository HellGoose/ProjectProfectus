class CreatePointsHistories < ActiveRecord::Migration
  def change
    create_table :points_histories do |t|
      t.integer   :points_received
      t.string    :description
      t.boolean   :seen

      t.timestamps null: false
    end
  end
end
