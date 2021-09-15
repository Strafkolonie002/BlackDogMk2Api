class OrderForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :order_type, String
  attribute :order_status, String
  attribute :order_details, Array[OrderDetailForm]
  attribute :order_info, Hash

  validates :slip_number, presence: true
  validates :order_type, inclusion: { in: ["receive", "ship"] }
  validates :order_status, presence: true
  validates :order_details, presence: true

end

