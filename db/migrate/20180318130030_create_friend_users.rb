class CreateFriendUsers < ActiveRecord::Migration
  def change
    create_table :friend_users do |t|
      t.string :email
      t.string :friend_email
      t.datetime :delete_at
      t.timestamps
    end
  end
end
