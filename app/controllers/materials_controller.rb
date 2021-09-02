class MaterialsController < ApplicationController
  def index
    materials = Material.order(created_at: :desc)
    render json: { message: "success", data: materials }
  end

  def create
    material = Material.new(material_params)
    if material.save
      render json: { message: 'success', data: [material] }
    else
      render json: { message: 'failure', errors: material.errors }
    end
  end

  def show
    render json: { message: 'success', data: [set_material] }
  end

  def update
    if set_material.update(material_params)
      render json: { message: 'success', data: [@material] }
    else
      render json: { message: 'failure', errors: [@material.errors] }
    end
  end

  def destroy
    set_material.destroy
    render json: { message: 'success', data: [@material] }
  end

  # for receipt_order
  def create_materials
    errors = Material.validate_create_materials_request(params)

    if errors.blank?
      created_materials = Material.bulk_insert(params)

      # Avoid to return material_properties as "{\"key\": \"value\"}" 
      created_materials.each do |single|
        single["material_properties"] = JSON.parse(single["material_properties"])
      end
      
      render json: { message: "success", data: created_materials }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  # for ship_order
  def update_materials
    errors = Material.validate_update_materials(params)
    if errors.blank?
      target_materials = Material.bulk_update_material_state(params)
      render json: { message: "success", data: target_materials }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  private
  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:item_code, :material_state_code, :container_code, material_properties: {})
  end

end
