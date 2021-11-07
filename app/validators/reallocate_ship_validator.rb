class ReallocateShipValidator < ActiveModel::Validator
  def validate(record)
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: record.slip_number)

    unless order.order_status == "shortage"
      return record.errors[:order] << "The status of this Order is not shortage"
    end

    reallocate_flag = false
    
    order.order_details.each { |od|
      materials = Material.where(item_id: od.item_id, material_status: "stocked")
      reallocate_flag = true  if od.quantity > materials.count
    }

    unless reallocate_flag
      return record.errors[:order] << "There are no enough stocked Materials"
    end
  end
end