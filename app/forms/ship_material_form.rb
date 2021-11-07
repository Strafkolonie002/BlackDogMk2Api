class ShipMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  validates :slip_number, presence: true
  validates_with ShipMaterialValidator
  
  def ship
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: self.slip_number)

    # マテリアルを出荷
    updated_materials = []
    order.order_details.each { |od|
      updated_materials.push(od.ship_order_detail_materials.update_all(material_status: "shipped", container_id: nil))
    }
    # orderのマテリアルが全て出荷されていたらorderのステータスをshippedに変更
    update_order_status(order) unless updated_materials.blank?

    updated_materials
  end

  def validate
    self.valid?
    self.errors
  end

  def update_order_status(order)
    material_status_list = []
    materials = []
    order.order_details.each { |od|
      materials += od.ship_order_detail_materials
    }
    materials.each do |m|
      material_status_list.push(m[:material_status])
    end

    order_shipped_flag = true
    material_status_list.each do |ms|
      order_shiped_flag = false unless ms == "shipped"
    end

    order.update!(order_status: "shipped") if order_shipped_flag == true
  end
end