class material_stateStatesController < ApplicationController

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
      render json: { message: 'success', data: [material_state] }
    else
      render json: { message: 'failure', errors: material_state.errors }
    end
  end

  def show
    @material_state = set_material_state
    render json: { message: 'success', data: [@material_state] }
  end

  def update
    @material_state = set_material_state
    if @material_state.update(material_state_params)
      render json: { message: 'success', data: [@material_state] }
    else
      render json: { message: 'failure', errors: [@material_state.errors] }
    end
  end

  def destroy
    @material_state = set_material_state
    render json: { message: 'success', data: [@material_state] }
  end

  private
  def set_material_state
    @material_state = MaterialState.find(params[:id])
  end

  def material_state_params
    params.require(:material_state).permit(:material_state_code, :material_state_name)
  end
end
