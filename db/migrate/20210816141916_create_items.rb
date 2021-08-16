class CreateItems < ActiveRecord::Migration[6.0]
  def change
    create_table :items do |t|
      t.string :item_code, null: false
      t.string :item_name, null: false
      t.jsonb :item_properties, null: false

      t.timestamps
    end
    add_index :items, [:item_code], unique: true
  end
end
