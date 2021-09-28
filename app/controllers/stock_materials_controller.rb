class StockMaterialsController < ApplicationController
  def index
    materials = Material.where(material_status: "stocked").order(created_at: :desc)
    render json: { message: "success", materials: materials }
  end

  def create
    stock_material = StockMaterialForm.new(stock_material_params)
    errors = stock_material.validate

    if errors.any?
      render json: { message: 'failure', errors: errors }
    else
      if stock_material.stock
        render json: { message: 'success', stock_material: stock_material }
      else
        render json: { message: 'failure', errors: stock_material.errors }
      end
    end
  end

  private
  def stock_material_params
    params.require(:stock_material).permit(:slip_number, :barcode_number, :container_code)
  end
end
