class TaskDetail < ApplicationRecord
  validates :task_code, presence: true, length: { maximum: 20 }
  validates :task_detail_number, presence: true, length: { maximum: 2 }
  validates :material_property_name, presence: true, length: { maximum: 20 }
end
