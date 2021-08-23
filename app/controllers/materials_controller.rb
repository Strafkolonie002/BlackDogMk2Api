class MaterialsController < ApplicationController
  def index
    materials = Material.order(created_at: :desc)
    render json: {
      message: "success",
      data: materials
    }
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
    @material = set_material
    render json: { message: 'success', data: [@material] }
  end

  def update
    @material = set_material
    if @material.update(material_params)
      render json: { message: 'success', data: [@material] }
    else
      render json: { message: 'failure', errors: [@material.errors] }
    end
  end

  def destroy
    @material = set_material
    render json: { message: 'success', data: [@material] }
  end

  def create_materials
    errors = Material.validate_receipt_order(params)

    if errors.blank?
      materials = Material.bulk_insert(params)

      # Avoid to return material_properties as "{\"key\": \"value\"}" 
      materials.each do |single|
        single["material_properties"] = JSON.parse(single["material_properties"])
      end
      
      render json: { message: "success", data: materials }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  private
  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:item_code, :material_state_code, material_properties: {})
  end

end
