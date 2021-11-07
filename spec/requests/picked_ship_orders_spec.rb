require 'rails_helper'

RSpec.describe "PickedShipOrders", type: :request do
  describe "GET /index" do
    it 'orderの全取得(picked)'do
      FactoryBot.create_list(:order, 10, order_status:"picked", order_type: "ship")

      get "/picked_ship_orders"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["orders"].length).to eq(Order.where(order_status: "picked").count)
    end
  end
end
