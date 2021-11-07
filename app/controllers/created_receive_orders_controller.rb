class CreatedReceiveOrdersController < ApplicationController
  def index
    orders = []
    Order.includes(order_details: :receive_order_detail_materials).where(order_type: "receive", order_status: "created").order(created_at: :desc).each { |o|
      order_hash = {
        order: o
      }
      order_details = []
      o.order_details.each { |od|
        item = Item.find(od.item_id)
        barcode = Barcode.find(od.item_id)
        quantity = od.receive_order_detail_materials.where(material_status: "created").count
        order_details.push({
          item_code: item.item_code,
          item_name: item.item_name,
          barcode_number: barcode.barcode_number,
          quantity: quantity
        })
      }

      order_hash[:order_details] = order_details
      orders.push(order_hash)
    }

    render json: { message: "success", orders: orders  }, status: :ok
  end
end
