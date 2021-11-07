class ShipMaterialValidator < ActiveModel::Validator
  def validate(record)
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: record.slip_number)

    if order.blank?
      return record.errors[:order] << "Order not found"
    end

    if order.order_status == "shipped"
      return record.errors[:order] << "This order already completed shipping"
    end

    if order.order_status != "picked"
      return record.errors[:order] << "This order do not completed picking"
    end

    materials = []
    order.order_details.each { |od|
      materials += od.ship_order_detail_materials
    }

    materials.select { |m| m[:material_status] == "picked"}

    if materials.blank?
      record.errors[:material] << "Material not found"
    end
  end
end