class OrderDetail < ApplicationRecord
  has_many :receive_order_detail_materials, class_name: 'Material', :foreign_key => 'receive_order_detail_id'
  has_many :ship_order_detail_materials, class_name: 'Material', :foreign_key => 'ship_order_detail_id'
  belongs_to :item

  validates :item_id, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end
