class CreateForums < ActiveRecord::Migration
  def change
    create_table :forums do |t|
      t.integer :topicCount
      t.integer :postCount
      t.belongs_to :project, index: true

      t.timestamps null: false
    end

  end
end
