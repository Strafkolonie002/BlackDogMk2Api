class AllocateMaterialsController < ApplicationController

  def index
    render json: { message: "success", orders: Order.where(order_status: "allocated").order(created_at: :desc) }, status: :ok
  end

  def update
    puts allocate_params
  end

  private

  def allocate_params
    params.require(:allocate_material).permit(:order_ids)
  end
end
