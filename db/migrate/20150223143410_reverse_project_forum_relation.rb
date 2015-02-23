class ReverseProjectForumRelation < ActiveRecord::Migration
  def change
  	remove_reference :forums, :project
  	add_reference :projects, :forum, index: true
  end
end
