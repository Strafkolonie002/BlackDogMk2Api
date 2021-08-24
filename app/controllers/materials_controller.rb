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

  # for receipt_order
  def create_materials
    errors = Material.validate_create_materials(params)

    if errors.blank?
      result = Material.bulk_insert(params)

      # Avoid to return material_properties as "{\"key\": \"value\"}" 
      result.each do |single|
        single["material_properties"] = JSON.parse(single["material_properties"])
      end
      
      render json: { message: "success", data: result }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  # for ship_order
  def update_materials
    errors = Material.validate_update_materials(params)
    if errors.blank?
      params[:data].each do |single|
        unless Material.allocate?(single[:item_code], params[:from_material_state_code], single[:quantity])
          return render json: { message: "failure", errors: [{error_info: ["Material shortage!!"], order: single}] }, status: 500
        end
      end
      render json: { message: "success", errors: errors }, status: :ok
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
