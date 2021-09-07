class ContainersController < ApplicationController
  def index
    containers = Container.order(created_at: :desc)
    render json: { message: "success", data: containers }
  end

  def create
    container = Container.new(container_params)
    if container.save
      render json: { message: 'success', data: [container] }
    else
      render json: { message: 'failure', errors: container.errors }
    end
  end

  def show
    render json: { message: 'success', data: [set_container] }
  end

  def update
    if set_container.update(container_params)
      render json: { message: 'success', data: [@container] }
    else
      render json: { message: 'failure', errors: [@container.errors] }
    end
  end

  def destroy
    set_container.destroy
    render json: { message: 'success', data: [@container] }
  end

  private
  def set_container
    @container = Container.find(params[:id])
  end

  def container_params
    params.require(:container).permit(:container_code, :container_type)
  end

end
