class StockMaterialValidator < ActiveModel::Validator
  def validate(record)
    barcode = Barcode.find_by(barcode_number: record.barcode_number)

    if barcode.blank?
      return record.errors[:barcode_number] << "Barcode not found"
    end
  
    order = Order.includes(order_details: :receive_order_detail_materials).find_by(slip_number: record.slip_number)

    if order.blank?
      return record.errors[:order] << "Order not found"
    end

    if order.order_status == "stocked"
      return record.errors[:order] << "This order already completed stocking"
    end

    materials = []
    order.order_details.each do |od|
      materials += od.receive_order_detail_materials
    end

    materials.select! { |m| m[:item_id] == barcode[:item_id] && m[:material_status] == "created"}

    if materials.blank?
      record.errors[:material] << "Material not found"
    end
  end
end