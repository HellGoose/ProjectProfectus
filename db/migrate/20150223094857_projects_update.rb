class ProjectsUpdate < ActiveRecord::Migration
  def change
  	create_join_table :products, :users, table_name: :project_votes
	create_join_table :products, :users, table_name: :project_reviews
  end
end
