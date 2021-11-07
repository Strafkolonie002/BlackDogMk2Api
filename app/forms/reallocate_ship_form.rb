class ReallocateShipForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  validates :slip_number, presence: true
  validates_with ReallocateShipValidator

  def reallocate
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: self.slip_number)

    # validationで欠品がないかチェックしているので全アロケート
    order.order_details.each { |od|
      materials = Material.where(item_id: od.item_id, material_status: "stocked").limit(od.quantity)
      materials.update(material_status: "allocated", ship_order_detail_id: od.id)
    }

    order.update(order_status: "allocated")
  end

  def validate
    self.valid?
    self.errors
  end
end