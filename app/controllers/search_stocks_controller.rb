class SearchStocksController < ApplicationController
  def create
    item = Item.find_by(stock_material_params)

    # itemが見つからない場合は空配列を返す
    if item.blank?
      render json: { message: "failure", materials: []}, status: :bad_request
    else
      materials = Material.includes(:container).where(item_id: item[:id], material_status: "stocked")
      stock_info = []

      materials.each { |m|
        stock_hash = {
          item_code: item.item_code,
          container_code: m.container.container_code
        }
        stock_info.push(stock_hash)
      }
      
      render json: { message: "success", materials: stock_info.group_by{ |m| m[:container_code]}}, status: :ok
    end
  end

  private
  def stock_material_params
    params.require(:search_stock).permit(:item_code)
  end
end
