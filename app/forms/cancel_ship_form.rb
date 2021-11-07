class CancelShipForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  validates :slip_number, presence: true
  validates_with CancelShipValidator

  def cancel
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: self.slip_number)
    materials = []
    order.order_details.each { |od|
      od.ship_order_detail_materials.update_all(material_status: "stocked")
    }
    order.update(order_status: "canceled")
    order
  end

  def validate
    self.valid?
    self.errors
  end
end