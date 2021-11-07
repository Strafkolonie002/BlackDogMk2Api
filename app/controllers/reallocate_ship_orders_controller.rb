class ReallocateShipOrdersController < ApplicationController
  def index
    orders = []
    Order.includes(:order_details).where(order_type: "ship", order_status: "shortage").order(created_at: :desc).each { |o|
      order_hash = {
        order: o
      }
      order_details = []
      o.order_details.each { |od|
        item = Item.find(od.item_id)
        barcode = Barcode.find(od.item_id)
        order_details.push({
          item_code: item.item_code,
          item_name: item.item_name,
          barcode_number: barcode.barcode_number,
        })
      }

      order_hash[:order_details] = order_details
      orders.push(order_hash)
    }

    render json: { message: "success", orders: orders  }, status: :ok
  end
  
  def create
    reallocate_ship_form = ReallocateShipForm.new(reallocate_params)
    errors = reallocate_ship_form.validate

    if errors.any?
      render json: { message: 'failure', errors: errors }, status: :bad_request
    else
      if reallocate_ship_form.reallocate
        render json: { message: 'success', order: reallocate_ship_form }, status: :ok
      else
        render json: { message: 'failure', errors: reallocate_ship_form.errors }, status: :bad_request
      end
    end
  end

  private
  def reallocate_params
    params.require(:reallocate_ship_order).permit(:slip_number)
  end
end
