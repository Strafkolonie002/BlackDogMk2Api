class Item < ApplicationRecord
  has_many :order_details
  has_many :materials

  validates :order_details, associated: true
  validates :materials, associated: true
  validates :item_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :item_name, presence: true, length: { maximum: 100 }
  validates :inspection, inclusion: { in: [true, false] }
  validates :creation_unit, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
