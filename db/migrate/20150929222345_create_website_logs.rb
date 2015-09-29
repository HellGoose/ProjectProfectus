class CreateWebsiteLogs < ActiveRecord::Migration
  def change
    create_table :website_logs do |t|
      t.string :website
      t.integer :tried

      t.timestamps null: false
    end
  end
end
