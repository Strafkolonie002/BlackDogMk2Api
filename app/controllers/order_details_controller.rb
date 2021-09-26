class OrderDetailsController < ApplicationController
  def index
    render json: { message: "success", order_details: OrderDetail.order(created_at: :desc) }, status: :ok
  end

  def create
    order_detail = OrderDetail.new(order_detail_params)
    if order_detail.save
      render json: { message: 'success', order_detail: order_detail }, status: :bad_request
    else
      render json: { message: 'failure', errors: order_detail.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', order_detail: set_order_detail }, status: :ok
  end

  def update
    if set_order_detail.update(order_detail_params)
      render json: { message: 'success', order_detail: @order_detail }, status: :ok
    else
      render json: { message: 'failure', errors: @order_detail.errors }, status: :bad_request
    end
  end

  def destroy
    set_order_detail.destroy
    render json: { message: 'success', order_detail: @order_detail }, status: :ok
  end

  private
  def set_order_detail
    @order_detail = OrderDetail.find(params[:id])
  end

  def order_detail_params
    params.require(:order_detail).permit(:order_id, :item_code, :quantity, order_detail_info: {})
  end
end
