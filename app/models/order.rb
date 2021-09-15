class Order < ApplicationRecord
  has_many :order_details

  validates :order_details, associated: true
  validates :slip_number, presence: true, uniqueness: true
  validates :order_type, inclusion: { in: ["receive", "ship"] }
  validates :order_status, presence: true
end
