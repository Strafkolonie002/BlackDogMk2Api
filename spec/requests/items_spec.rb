require 'rails_helper'

RSpec.describe "Items", type: :request do
  describe "GET /index" do
    it 'itemの全取得' do
      FactoryBot.create_list(:item, 10)
      get "/items"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["items"].length).to eq(Item.count)
    end
  end

  describe "POST /creste" do
    it 'itemの作成' do
      create_params = {
        item: {
          item_code: "test_code1",
          item_name: "test_name1",
          inspection: true,
          creation_unit: 1
        }
      }
      count = Item.count
      post "/items", params: create_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Item.count).to eq(count + 1)
    end

    it 'item作成時のエラー' do
      create_params = {
        item: {
          item_code: nil,
          item_name: "test_name1",
          inspection: true,
          creation_unit: 1
        }
      }
      post "/items", params: create_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(400)
    end
  end
end
