class PickMaterialValidator < ActiveModel::Validator
  def validate(record)
    barcode = Barcode.find_by(barcode_number: record.barcode_number)
    stock_container = Container.find_by(container_code: record.stock_container_code)
    pick_container = Container.find_by(container_code: record.pick_container_code)
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: record.slip_number)

    if order.blank?
      return record.errors[:order] << "Order not found"
    end

    if order.order_status == "picked"
      return record.errors[:order] << "This order already completed picking"
    end

    if order.order_status != "allocated"
      return record.errors[:order] << "This order do not completed allocating"
    end

    if stock_container.blank?
      return record.errors[:container] << "Stock Container not found"
    end

    unless pick_container.container_type == "Pick"
      return record.errors[:pick_container] << "select the container that type is pick as pick container"
    end

    if Container.find_by(container_code: record.pick_container_code).blank?
      return record.errors[:container] << "Pick Container not found"
    end

    materials = []
    order.order_details.each { |od|
      materials += od.ship_order_detail_materials
    }

    materials.select! { |m|
      m[:item_id] == barcode[:item_id] &&
      m[:material_status] == "allocated" &&
      m[:container_id] == stock_container[:id]
    }

    if materials.blank?
      record.errors[:material] << "Material not found"
    end
  end
end