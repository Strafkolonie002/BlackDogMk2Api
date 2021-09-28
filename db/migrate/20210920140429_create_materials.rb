class CreateMaterials < ActiveRecord::Migration[6.0]
  def change
    create_table :materials do |t|
      t.references :receive_order_detail
      t.references :ship_order_detail
      t.references :item, nul: false, foreign_key: true
      t.string :material_status, null: false
      t.references :container, foreign_key: true

      t.timestamps
    end
    add_foreign_key :materials, :order_details, column: :receive_order_detail_id
    add_foreign_key :materials, :order_details, column: :ship_order_detail_id
  end
end
