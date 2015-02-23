class DestroyIterations < ActiveRecord::Migration
  def change
  	drop_table :iterations
  end
end
