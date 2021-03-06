class MaterialsController < ApplicationController
  def index
    materials = Material.order(created_at: :desc)
    render json: { message: "success", materials: materials }, status: :ok
  end

  def create
    material = Material.new(material_params)
    if material.save
      render json: { message: 'success', material: material }, status: :ok
    else
      render json: { message: 'failure', errors: material.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', material: set_material }, status: :ok
  end

  def update
    if set_material.update(material_params)
      render json: { message: 'success', material: @material }, status: :ok
    else
      render json: { message: 'failure', errors: @material.errors }, status: :bad_request
    end
  end

  def destroy
    set_material.destroy
    render json: { message: 'success', material: @material }, status: :ok
  end

  private
  def set_material
    @material = Material.find(params[:id])
  end

  def material_params
    params.require(:material).permit(:receive_order_detail_id, :ship_order_detail_id, :item_id, :material_status, :container_id)
  end
end
