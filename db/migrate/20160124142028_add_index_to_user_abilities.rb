class AddIndexToUserAbilities < ActiveRecord::Migration
  def change
  	add_column :abilities_users, :id, :primary_key
  end
end
