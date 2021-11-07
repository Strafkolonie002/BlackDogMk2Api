require 'rails_helper'

RSpec.describe "Orders", type: :request do
  # type:receive
  describe "GET /index" do
    it 'order全取得' do
      10.times do 
        FactoryBot.create(:order, order_type: "receive")
      end
      
      get "/receive_orders"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["orders"].length).to eq(Order.count)      
    end
  end

  describe "POST /create" do
    it 'order作成' do
      item = Item.create(
        item_code: "test_code1",
        item_name: "test_name1",
        inspection: true,
        creation_unit: 1
      )
  
      create_params = {
        receive_order: {
          orders: [
            {
              slip_number: "20",
              order_details: [
                {
                  item_code: item[:item_code],
                  quantity: 10
                }
              ]
            }
          ]
        }
      }
  
      count = Order.count
      post "/receive_orders", params: create_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Order.count).to eq(count + 1)
    end
  end
end
