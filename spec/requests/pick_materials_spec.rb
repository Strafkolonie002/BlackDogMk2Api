require 'rails_helper'

RSpec.describe "PickMaterials", type: :request do
  describe "POST /create" do
    it 'ピックを実行してオーダーステータスがpickedになる' do
      from = FactoryBot.create(:container, container_type: "Stock")
      to = FactoryBot.create(:container, container_type: "Pick")
      item = FactoryBot.create(:item)
      barcode = FactoryBot.create(:barcode, item_id: item.id, item_code: item.item_code)
      order = FactoryBot.create(:order, order_status: "allocated", order_type: "ship")
      order_detail = FactoryBot.create(:order_detail, order_id: order.id, item_id: item.id)
      material = FactoryBot.create(
        :material, 
        material_status: "allocated",
        container_id: from.id,
        item_id: item.id,
        ship_order_detail_id: order_detail.id
      )

      post_params = {
        pick_material: {
          slip_number: order.slip_number,
          barcode_number: barcode.barcode_number,
          stock_container_code: from.container_code,
          pick_container_code: to.container_code
        }
      }

      post "/pick_materials", params: post_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Order.find(order.id).order_status).to eq("picked")
      expect(Material.find(material.id).container_id).to eq(to.id) 
    end
  end
end
