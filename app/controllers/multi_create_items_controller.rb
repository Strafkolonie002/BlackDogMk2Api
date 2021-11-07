class MultiCreateItemsController < ApplicationController
  def create
    mci = MultiCreateItemForm.new(multi_create_item_params)
    errors = mci.validate

    if errors.any?
      render json: { message: 'failure', errors: errors }, status: :bad_request
    else
      result = mci.create
      render json: { message: 'success', items: result }, status: :ok
    end
  end

  private
  def multi_create_item_params
    params.require(:multi_create_item).permit({ items: [:item_code, :item_name, :creation_unit, barcodes: []] })
  end
end