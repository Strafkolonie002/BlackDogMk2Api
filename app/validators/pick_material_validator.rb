class PickMaterialValidator < ActiveModel::Validator
  def validate(record)
    barcode = Barcode.find_by(barcode_number: record.barcode_number)
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: record.slip_number)

    if order.blank?
      return record.errors[:order] << "Order not found"
    end

    if order.order_status == "picked"
      return record.errors[:order] << "This order already completed picking"
    end

    materials = []
    order.order_details.each { |od|
      materials += od.ship_order_detail_materials
    }

    materials.select { |m| m[:item_id] == barcode[:item_id] && m[:material_status] == "allocated"}

    if materials.blank?
      record.errors[:material] << "Material not found"
    end
  end
end