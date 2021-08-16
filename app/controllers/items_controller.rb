class ItemsController < ApplicationController

  def index
    items = Item.order(created_at: :desc)
    render json: {
      message: "success",
      data: items
    }
  end

  def create
    item = Item.new(item_params)
    if item.save
      render json: { message: 'success', data: [item] }
    else
      render json: { message: 'failure', errors: item.errors }
    end
  end

  def bulk_insert
    errors = Item.validate_create(params)

    if errors.blank?
      data = params[:data]

      data.each do |single|
        # create item_properties as {}, when it is null
        single[:item_properties] = {} if single[:item_properties].blank?
        single[:created_at] = Time.now
        single[:updated_at] = Time.now
      end

      items = Item.insert_all(data, unique_by: :item_code, returning: %i[id item_code])
      render json: { message: "success", data: items }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  def show
    @item = set_item
    render json: { message: 'success', data: [@item] }
  end

  def update
    @item = set_item
    if @item.update(item_params)
      render json: { message: 'success', data: [@item] }
    else
      render json: { message: 'failure', errors: [@item.errors] }
    end
  end

  def destroy
    @item = set_item
    render json: { message: 'success', data: [@item] }
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_code, :item_name, item_properties: {})
  end

end
