class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.string :item_code, null: false
      t.string :material_state_code, null: false
      t.jsonb :material_properties, null: false

      t.timestamps
    end
  end
end
