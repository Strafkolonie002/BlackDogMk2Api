require 'rails_helper'

RSpec.describe "SearchStocks", type: :request do
  describe "POST /create" do
    it '商品コードからコンテナ単位で在庫を検索' do
      container = FactoryBot.create(:container)
      item = FactoryBot.create(:item)
      FactoryBot.create(
        :material,
        container_id: container.id,
        material_status: "stocked",
        item_id: item.id
      )

      post_params = {
        search_stock: {
          item_code: item.item_code
        }
      }

      post "/search_stocks", params: post_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
    end
  end
end
