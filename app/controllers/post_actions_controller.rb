class PostActionsController < ApplicationController

  def index
    post_actions = PostAction.order(created_at: :desc)
    render json: {
      message: "success",
      data: post_actions
    }
  end

  def create
    post_action = PostAction.new(post_action_params)
    if post_action.save
      render json: { message: 'success', data: [post_action] }, status: :ok
    else
      render json: { message: 'failure', errors: post_action.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', data: [set_post_action] }, status: :ok
  end

  def update
    if set_post_action.update(post_action_params)
      render json: { message: 'success', data: [@post_action] }, status: :ok
    else
      render json: { message: 'failure', errors: [@post_action.errors] }, status: :bad_request
    end
  end

  def destroy
    set_post_action.destroy
    render json: { message: 'success', data: [@post_action] }, status: :ok
  end

  private
  def set_post_action
    @post_action = PostAction.find(params[:id])
  end

  def post_action_params
    params.require(:post_action).permit(:post_action_code, :post_action_name, :method_name)
  end

end
