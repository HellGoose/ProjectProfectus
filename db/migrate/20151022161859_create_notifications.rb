class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.integer :points
      t.string :notification
      t.text :icon
      t.text :link
      t.boolean :seen
      t.boolean :popup
      t.references :user, index: true

      t.timestamps null: false
    end
    add_foreign_key :notifications, :users
  end
end
