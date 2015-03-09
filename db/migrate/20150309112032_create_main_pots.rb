class CreateMainPots < ActiveRecord::Migration
  def change
    create_table :main_pots do |t|
    	t.float :amount
      t.timestamps null: false
    end
  end
end
