class DestroyReviews < ActiveRecord::Migration
  def change
  	drop_table :project_reviews
  end
end
