class FixPostComment < ActiveRecord::Migration
  def change
  	add_column :post_comments, :id, :integer
  	add_index :post_comments, :id
  	add_reference :post_comments, :comment_id, class_name: "Post", index: true
  end
end
