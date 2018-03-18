class CreateSubscribeUsers < ActiveRecord::Migration
  def change
    create_table :subscribe_users do |t|
      t.string :email
      t.string :subscribe_email
      t.datetime :delete_at
      t.timestamps
    end
  end
end
