class ShipMaterialsController < ApplicationController
  def index
    materials = Material.where(material_status: "shipped").order(created_at: :desc)
    render json: { message: "success", materials: materials }, status: :ok
  end

  def create
    ship_material = ShipMaterialForm.new(ship_material_params)
    errors = ship_material.validate

    if errors.any?
      render json: { message: 'failure', errors: errors }, status: :bad_request
    else
      updated_materials = ship_material.ship
      unless updated_materials.blank?
        render json: { message: 'success', ship_material: ship_material }, status: :ok
      else
        render json: { message: 'failure', errors: ship_material.errors }, status: :bad_request
      end
    end
  end

  private
  def ship_material_params
    params.require(:ship_material).permit(:slip_number)
  end
end
