class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.text :content
      t.text :tags
      t.boolean :flagged
      t.integer :voteCount
      t.integer :finalVoteCount
      t.string :logoLink
      t.boolean :isGettingFunded

      t.timestamps null: false
    end
  end
end
