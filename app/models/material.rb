class Material < ApplicationRecord
  belongs_to :receive_order_detail, class_name: 'OrderDetail', :foreign_key => 'receive_order_detail_id'
  belongs_to :ship_order_detail, class_name: 'OrderDetail', :foreign_key => 'ship_order_detail_id', optional: true
  belongs_to :item
  belongs_to :container, optional: true

  validates :receive_order_detail_id, presence: true
  validates :item_id, presence: true
  validates :material_status, presence: true, length: { maximum: 20 }, inclusion: { in: ["created", "receive inspected", "stocked", "allocated", "ship inspected", "picked", "shipped", "disposed"] }
end
