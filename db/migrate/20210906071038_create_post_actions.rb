class CreatePostActions < ActiveRecord::Migration[6.0]
  def change
    create_table :post_actions do |t|
      t.string :post_action_code, null: false
      t.string :post_action_name, null: false
      t.string :method_name, null: false

      t.timestamps
    end
    add_index :post_actions, [:post_action_code], unique: true
  end
end
