class ShipOrdersController < ApplicationController

  def index
    render json: { message: "success", orders: Order.where(order_type: "ship").order(created_at: :desc) }, status: :ok
  end

  def create
    @order_collection_form = OrderCollectionForm.new(order_collection_form_params)
    error_list = @order_collection_form.validate_params

    if error_list.blank?
      result = @order_collection_form.create_ship_order

      render json: { message: 'success', orders: result }, status: :ok
    else
      render json: { message: 'failure', errors: error_list }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', order: set_order }, status: :ok
  end

  def update
    if set_order.update(order_params)
      render json: { message: 'success', order: @order }, status: :ok
    else
      render json: { message: 'failure', errors: errors }, status: :bad_request
    end
  end

  def destroy
    set_order.destroy
    render json: { message: 'success', order: @order }, status: :ok
  end

  private
  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    order_status = "created"
    params.require(:order_form).permit(:order_type, { order_details_attributes:[:item_code, :quantity] }, order_info: {}).merge(order_status: order_status)
  end

  def order_collection_form_params
    params.require(:ship_order).permit({ orders: [:slip_number, { order_details: [:item_code, :quantity] }, order_info: {}] })
  end

end
