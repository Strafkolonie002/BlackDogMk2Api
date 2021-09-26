class OrderForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :order_details, Array[OrderDetailForm]
  attribute :order_info, Hash

  validates :slip_number, presence: true
  validates_with SlipNumberValidator
  validates :order_details, presence: true

end

