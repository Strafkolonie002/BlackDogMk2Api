class ContainersController < ApplicationController
  def index
    containers = Container.order(created_at: :desc)
    render json: { message: "success", containers: containers }, status: :ok
  end

  def create
    container = Container.new(container_params)
    if container.save
      render json: { message: 'success', containers: container }, status: :ok
    else
      render json: { message: 'failure', errors: container.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', container: set_container }, status: :ok
  end

  def update
    if set_container.update(container_params)
      render json: { message: 'success', container: @container }, status: :ok
    else
      render json: { message: 'failure', errors: @container.errors }, status: :bad_request
    end
  end

  def destroy
    set_container.destroy
    render json: { message: 'success', container: @container }, status: :ok
  end

  private
  def set_container
    @container = Container.find(params[:id])
  end

  def container_params
    params.require(:container).permit(:container_code, :container_type)
  end

end
