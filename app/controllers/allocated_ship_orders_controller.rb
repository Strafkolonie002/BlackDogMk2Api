class AllocatedShipOrdersController < ApplicationController
  def index
    orders = []
    Order.includes(order_details: :ship_order_detail_materials).where(order_type: "ship", order_status: "allocated").order(created_at: :desc).each { |o|
      order_info = {
        order: o
      }
      order_details = []
      materials = []
      o.order_details.each { |od|
        item = Item.find(od.item_id)
        barcode = Barcode.find(od.item_id)

        detail_materials = od.ship_order_detail_materials.includes(:container).where(material_status: "allocated")

        # container x item 単位でmaterialをグルーピングして出力する
        grouped_by_container = detail_materials.group_by{ |m| m[:container_id]}
        grouped_by_container.each { |cm|
        
          # 配列cmのindex0にはグルーピングキー、1にはデータが格納されている
          # cm[1][0]でグルーピングしたmaterialの初めのデータが取得できる
          # order_detail->materialsで取得している場合、oder_detailはitem単位なのでmaterialのitemも同じになる
          grouped_hash = {
            item_code: item.item_code,
            item_name: item.item_name,
            barcode_number: barcode.barcode_number,
            container_code: Container.find(cm[1][0].container_id).container_code,
            quantity: cm[1].count,
          }
          materials.push(grouped_hash)
        }
      }
      
      order_info[:pick_materials] = materials
      orders.push(order_info)
    }

    render json: { message: "success", orders: orders  }, status: :ok
  end
end
