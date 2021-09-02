class TasksController < ApplicationController

  def index
    tasks = Task.order(created_at: :desc)
    render json: { message: "success", data: tasks }
  end

  def create
    task = Task.new(task_params)
    if task.save
      render json: { message: 'success', data: [task] }
    else
      render json: { message: 'failure', errors: task.errors }
    end
  end

  def show
    render json: { message: 'success', data: [set_task] }
  end

  def update
    if set_task.update(task_params)
      render json: { message: 'success', data: [@task] }
    else
      render json: { message: 'failure', errors: [@task.errors] }
    end
  end

  def destroy
    set_task.destroy
    render json: { message: 'success', data: [@task] }
  end

  def execute
    @task = Task.find_by(task_code: params[:task_code])
    unless @task.blank?
      errors = @task.validate_execute_request(params)
      if errors.blank?
        render json: { message: 'success', data: @task.execute_task(params) }
      else
        render json: { message: 'failure', errors: errors }
      end
    else
      render json: { message: 'failure', errors: [{ error_info: ["task_code:#{params[:task_code]} not found"] }] }
    end
  end

  private
  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:task_code, :task_name, :dest_material_state_code, :post_action, search_properties: [], task_properties: {})
  end

end
