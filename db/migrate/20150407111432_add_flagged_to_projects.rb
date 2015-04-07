class AddFlaggedToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :flagged, :integer
  end
end
