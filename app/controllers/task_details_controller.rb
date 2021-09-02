class TaskDetailsController < ApplicationController

  def index
    task_details = TaskDetail.order(created_at: :desc)
    render json: { message: "success", data: task_details }
  end

  def create
    task_detail = TaskDetail.new(task_detail_params)
    if task_detail.save
      render json: { message: 'success', data: [task_detail] }
    else
      render json: { message: 'failure', errors: task_detail.errors }
    end
  end

  def show
    render json: { message: 'success', data: [set_task_detail] }
  end

  def update
    if set_task_detail.update(task_detail_params)
      render json: { message: 'success', data: [@task_detail] }
    else
      render json: { message: 'failure', errors: [@task_detail.errors] }
    end
  end

  def destroy
    set_task_detail.destroy
    render json: { message: 'success', data: [@task_detail] }
  end

  private
  def set_task_detail
    @task_detail = TaskDetail.find(params[:id])
  end

  def task_detail_params
    params.require(:task_detail).permit(:task_code, :task_detail_number, :material_property_name)
  end

end
