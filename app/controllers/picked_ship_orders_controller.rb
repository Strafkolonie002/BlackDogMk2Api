class PickedShipOrdersController < ApplicationController
  def index
    orders = Order.where(order_type: "ship", order_status: "picked").order(created_at: :desc)
    render json: { message: "success", orders: orders  }, status: :ok
  end
end
