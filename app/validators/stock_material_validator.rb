class StockMaterialValidator < ActiveModel::Validator
  def validate(record)
    barcode = Barcode.find_by(barcode_number: record.barcode_number)
    order = Order.find_by(slip_number: record.slip_number)

    if order.blank?
      return record.errors[:order] << "Order not found"
    end

    order_details = OrderDetail.where(order_id: order[:id])

    material_list = []
    order_details.each do |od|
      materials = Material.where(order_detail_id: od[:id])
      material_list = material_list + materials
    end

    puts "pinorape #{material_list.count}"

    to_stock_materials = material_list.select { |m| m[:item_id] == barcode[:item_id] && m[:material_status] == "created"}

    if to_stock_materials.blank?
      record.errors[:material] << "Material not found"
    end
  end
end