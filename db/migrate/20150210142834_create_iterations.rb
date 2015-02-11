class CreateIterations < ActiveRecord::Migration
  def change
    create_table :iterations do |t|
      t.date :startDate
      t.date :endDate
      t.float :totalAmount

      t.timestamps null: false
    end
  end
end
