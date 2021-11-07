require 'rails_helper'

RSpec.describe "AllocatedShipOrders", type: :request do
  describe "GET /index" do
    it 'orderを取得' do
      container = FactoryBot.create(:container)
      order = FactoryBot.create(:order, order_status: "allocated", order_type: "ship")
      order_detail = FactoryBot.create(:order_detail, order_id: order.id)
      material = FactoryBot.create(:material, container_id: container.id, material_status: "allocated", ship_order_detail_id: order_detail.id)
      barcode = FactoryBot.create(:barcode)
      get "/allocated_ship_orders"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["orders"].length).to eq(Order.where(order_status: "allocated").count)
    end
  end
end
