class MaterialState < ApplicationRecord
  validates :material_state_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :material_state_name, presence: true, length: { maximum: 100 }
end
