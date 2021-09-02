class CreateTaskDetails < ActiveRecord::Migration[6.0]
  def change
    create_table :task_details do |t|
      t.string :task_code
      t.integer :task_detail_number
      t.string :material_property_name

      t.timestamps
    end
  end
end
