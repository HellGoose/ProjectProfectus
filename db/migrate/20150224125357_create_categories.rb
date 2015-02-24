class CreateCategories < ActiveRecord::Migration
  def change
    add_reference :projects, :category, index: true
  end
end
