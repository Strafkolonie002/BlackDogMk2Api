class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.string :order_detail_id, null: false
      t.references :item, nul: false, foreign_key: true
      t.string :material_status, null: false
      t.references :container, foreign_key: true

      t.timestamps
    end
  end
end
