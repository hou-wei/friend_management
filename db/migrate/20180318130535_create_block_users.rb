class CreateBlockUsers < ActiveRecord::Migration
  def change
    create_table :block_users do |t|
      t.string :email
      t.string :block_email
      t.datetime :delete_at
      t.timestamps
    end
  end
end
