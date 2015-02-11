class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :provider
      t.string :uid
      t.string :oauth_token
      t.datetime :oauth_token_expires_at
      t.string :username
      t.string :email
      t.string :address
      t.string :phone
      t.datetime :bannedUntil
      t.float :subscriptionAmount
      t.integer :points
      t.integer :role

      t.timestamps null: false
    end
  end
end
