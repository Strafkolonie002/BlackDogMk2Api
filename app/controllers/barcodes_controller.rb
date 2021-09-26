class BarcodesController < ApplicationController

  def index 
    render json: { message: "success", barcodes: Barcode.order(created_at: :desc) }, status: :ok
  end

  def create
    item = Item.find_by(item_code: barcode_params[:item_code])
    if item.blank?
      render json: { message: 'failure', errors: { "item_code": ["item not found"]} }, status: :bad_request
    else
      barcode = Barcode.new(item_id: item[:id], item_code: item.item_code, barcode_number: barcode_params[:barcode_number])
      if barcode.save
        render json: { message: 'success', barcode: barcode }, status: :ok
      else
        render json: { message: 'failure', errors: barcode.errors }, status: :bad_request
      end
    end
  end

  def show
    render json: { message: 'success', barcode: set_barcode }, status: :ok
  end

  def update
    if set_barcode.update(barcode_params)
      render json: { message: 'success', barcode: @barcode }, status: :ok
    else
      render json: { message: 'failure', errors: @barcode.errors }, status: :bad_request
    end
  end

  def destroy
    set_barcode.destroy
    render json: { message: 'success', barcode: @barcode }, status: :ok
  end

  private
  def set_barcode
    @barcode = barcode.find(params[:id])
  end

  def barcode_params
    params.require(:barcode).permit(:barcode_number, :item_code, :item_code)
  end
end
