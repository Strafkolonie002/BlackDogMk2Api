class PickMaterialsController < ApplicationController
  def index
    materials = Material.where(material_status: "picked").order(created_at: :desc)
    render json: { message: "success", materials: materials }, status: :ok
  end

  def create
    pick_material = PickMaterialForm.new(pick_material_params)
    errors = pick_material.validate
    
    if errors.any?
      render json: { message: 'failure', errors: errors }, status: :bad_request
    else
      if pick_material.pick
        render json: { message: 'success', pick_material: pick_material }, status: :ok
      else
        render json: { message: 'failure', errors: pick_material.errors }, status: :bad_request
      end
    end
  end

  private
  def pick_material_params
    params.require(:pick_material).permit(:slip_number, :barcode_number, :stock_container_code, :pick_container_code)
  end
end
