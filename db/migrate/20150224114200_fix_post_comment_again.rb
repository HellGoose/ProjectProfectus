class FixPostCommentAgain < ActiveRecord::Migration
  def change
  	remove_column :post_comments, :comment_id_id
  	add_reference :post_comments, :comment, class_name: "Post", index: true
  	remove_column :post_comments, :post_id
  	add_reference :post_comments, :post, class_name: "Post", index: true

  end
end
