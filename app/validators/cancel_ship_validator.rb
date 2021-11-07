class CancelShipValidator < ActiveModel::Validator
  def validate(record)
    order = Order.find_by(slip_number: record.slip_number)
    if order.blank?
      record.errors[:order] << "Order not found"
    end

    if order.order_type != "ship"
      record.errors[:order] << "This Order is not Ship Order"
    end

    if order.order_status == "shipped"
      record.errors[:order] << "This Order is already shipped"
    end

    if order.order_status == "canceled"
      record.errors[:order] << "This Order is already canceled"
    end
  end
end