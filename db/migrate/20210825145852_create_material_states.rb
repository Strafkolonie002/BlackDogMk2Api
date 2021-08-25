class CreateMaterialStates < ActiveRecord::Migration[6.0]
  def change
    create_table :material_states do |t|
      t.string :material_state_code
      t.string :material_state_name

      t.timestamps
    end
    add_index :material_states, [:material_state_code], unique: true
  end
end
