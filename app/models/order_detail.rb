class OrderDetail < ApplicationRecord
  belongs_to :order
  belongs_to :item
  has_many :materials

  validates :materials, associated: true
  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
