class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :user_code, null: false
      t.string :user_name, null: false
      t.string :password_digest, null: false

      t.timestamps
    end
    add_index :users, [:user_code], unique: true
  end
end
