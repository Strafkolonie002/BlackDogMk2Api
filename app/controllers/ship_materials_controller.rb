class ShipMaterialsController < ApplicationController
  def index
    materials = Material.where(material_status: "shipped").order(created_at: :desc)
    render json: { message: "success", materials: materials }
  end

  def create
    ship_material = ShipMaterialForm.new(ship_material_params)
    errors = ship_material.validate

    if errors.any?
      render json: { message: 'failure', errors: errors }
    else
      updated_materials = ship_material.ship
      unless updated_materials.blank?
        render json: { message: 'success', ship_material: ship_material }
      else
        render json: { message: 'failure', errors: ship_material.errors }
      end
    end
  end

  private
  def ship_material_params
    params.require(:ship_material).permit(:slip_number, :container_code)
  end
end
