class CancelShipOrdersController < ApplicationController
  def index
    render json: { message: "success", orders: Order.where(order_status: "canceled").order(created_at: :desc) }, status: :ok
  end

  def create
    @cancel_ship_form = CancelShipForm.new(cancel_ship_form_params)
    error_list = @cancel_ship_form.validate

    if error_list.blank?
      result = @cancel_ship_form.cancel

      render json: { message: 'success', orders: result }, status: :ok
    else
      render json: { message: 'failure', errors: error_list }, status: :bad_request
    end
  end

  private
  def cancel_ship_form_params
    params.require(:cancel_ship_order).permit(:slip_number)
  end
end
