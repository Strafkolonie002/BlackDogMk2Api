class ItemsController < ApplicationController
  def index
    render json: { message: "success", items: Item.order(created_at: :desc) }, status: :ok
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: { message: 'success', item: item }, status: :bad_request
    else
      render json: { message: 'failure', errors: item.errors }, status: :bad_request
    end
  end

  def show
    render json: { message: 'success', item: set_item }, status: :ok
  end

  def update
    if set_item.update(item_params)
      render json: { message: 'success', item: @item }, status: :ok
    else
      render json: { message: 'failure', errors: @item.errors }, status: :bad_request
    end
  end

  def destroy
    set_item.destroy
    render json: { message: 'success', item: @item }, status: :ok
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_code, :item_name, :inspection, :creation_unit)
  end
end
