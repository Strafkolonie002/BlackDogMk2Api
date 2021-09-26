class CreateBarcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :barcodes do |t|
      t.string :barcode_number, null: false
      t.string :item_code, null: false
      t.references :item, null: false, foreign_key: true
      t.timestamps
    end
    add_index :barcodes,:barcode_number ,unique: true
  end
end
