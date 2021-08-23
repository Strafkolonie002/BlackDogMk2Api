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

  def bulk_upsert
    errors = Item.validate_bulk_upsert(params)

    if errors.blank?
      data = Item.add_time_and_properties(params[:data])
      items = Item.upsert_all(data, unique_by: :item_code, returning: %i[id item_code item_name item_properties])

      # Avoid to return item_properties as "{\"key\": \"value\"}" 
      items.each do |single|
        single["item_properties"] = JSON.parse(single["item_properties"])
      end
      
      render json: { message: "success", data: items }, status: :ok
    else
      render json: { message: "failure", errors: errors }, status: :bad_request
    end
  end

  private
  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(:item_code, :item_name, item_properties: {})
  end

end
