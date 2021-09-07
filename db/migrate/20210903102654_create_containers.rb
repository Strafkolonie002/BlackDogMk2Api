class CreateContainers < ActiveRecord::Migration[6.0]
  def change
    create_table :containers do |t|
      t.string :container_code, null: false
      t.string :container_type

      t.timestamps
    end
    add_index :containers, [:container_code], unique: true
  end
end
