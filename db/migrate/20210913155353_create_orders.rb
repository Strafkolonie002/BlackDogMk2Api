class CreateOrders < ActiveRecord::Migration[6.0]
  def change
    create_table :orders do |t|
      t.string :slip_number, null: false
      t.string :order_type, null: false
      t.string :order_status, null: false
      t.jsonb :order_info

      t.timestamps
    end
    add_index :orders, [:slip_number], unique: true
  end
end
