class Material < ApplicationRecord
  belongs_to :order_detail
  belongs_to :item

  validates :order_detail_id, presence: true
  validates :item_id, presence: true
  validates :material_status, presence: true, length: { maximum: 20 }, inclusion: { in: ["created", "receive inspected", "stocked", "allocated", "ship inspected", "shipped", "disposed"] }
end
