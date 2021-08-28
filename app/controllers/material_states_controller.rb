class MaterialStatesController < ApplicationController

  def index
    material_states = MaterialState.order(created_at: :desc)
    render json: {
      message: "success",
      data: material_states
    }
  end

  def create
    material_state = MaterialState.new(material_state_params)
    if material_state.save
      render json: { message: 'success', data: [material_state] }, status: :ok
    else
      render json: { message: 'failure', errors: material_state.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', data: [set_material_state] }, status: :ok
  end

  def update
    if set_material_state.update(material_state_params)
      render json: { message: 'success', data: [@material_state] }, status: :ok
    else
      render json: { message: 'failure', errors: [@material_state.errors] }, status: :bad_request
    end
  end

  def destroy
    set_material_state.destroy
    render json: { message: 'success', data: [@material_state] }, status: :ok
  end

  private
  def set_material_state
    @material_state = MaterialState.find(params[:id])
  end

  def material_state_params
    params.require(:material_state).permit(:material_state_code, :material_state_name)
  end
  
end
