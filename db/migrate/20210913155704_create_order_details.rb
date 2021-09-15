class CreateOrderDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :order_details do |t|
      t.references :order, foreign_key: true
      t.references :item, foreign_key: true
      t.integer :quantity, null: false

      t.timestamps
    end
  end
end
