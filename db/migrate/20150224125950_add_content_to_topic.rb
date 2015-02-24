class AddContentToTopic < ActiveRecord::Migration
  def change
  	add_column :topics, :content, :text
  end
end
