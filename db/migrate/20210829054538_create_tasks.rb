class CreateTasks < ActiveRecord::Migration[6.0]
  def change
    create_table :tasks do |t|
      t.string :task_code, null: false
      t.string :task_name, null: false
      t.string :search_properties, null: false, default: [], array: true
      t.string :dest_material_state_code
      t.string :post_action
      t.jsonb :task_properties, null: false, default: {}

      t.timestamps
    end
    add_index :tasks, [:task_code], unique: true
  end
end
