class CreateAbilities < ActiveRecord::Migration
  def change
    create_table :abilities do |t|
    	t.string :name
    	t.string :description
    	t.integer :reqLevel
    	t.integer :maxCharges
    	t.integer :rechargeRate
    	t.string :target
      t.timestamps null: false
    end
    create_table :abilities_users, id: false do |t|
    	t.belongs_to :user, index: true
    	t.belongs_to :ability, index: true
    	t.integer :charges
    end
  end
end
