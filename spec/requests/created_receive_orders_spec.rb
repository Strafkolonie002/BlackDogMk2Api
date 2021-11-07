require 'rails_helper'

RSpec.describe "CreatedReceiveOrders", type: :request do
  describe "GET /index" do
    it 'order全取得(created)' do
      order = FactoryBot.create(:order, order_status: "created", order_type: "receive")
      get "/created_receive_orders"
      json = JSON.parse(response.body)
      
      expect(response.status).to eq(200)
      expect(json["orders"].length).to eq(Order.where(order_status: "created").count)
    end
  end
end
