class AddIsCommentToPosts < ActiveRecord::Migration
  def change
  	add_column :posts, :isComment, :boolean
  end
end
