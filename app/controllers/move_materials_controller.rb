class MoveMaterialsController < ApplicationController
  def create
    move_material = MoveMaterialForm.new(move_material_params)
    errors = move_material.validate
    if errors.any?
      render json: { message: 'failure', errors: errors }, status: :bad_request
    else
      if move_material.move
        render json: { message: 'success', move_material: move_material }, status: :ok
      else
        render json: { message: 'failure', errors: move_material.errors }, status: :bad_request
      end
    end
  end

  private
  def move_material_params
    params.require(:move_material).permit(:barcode_number, :from_container_code, :to_container_code)
  end
end
