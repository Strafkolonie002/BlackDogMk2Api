require 'rails_helper'

RSpec.describe "Barcodes", type: :request do
  describe "GET /index" do
    it 'barcode全取得' do
      item = Item.create(
        item_code: "test_code1",
        item_name: "test_name1",
        inspection: true,
        creation_unit: 1
      )

      # 同一itemに3つ紐付け
      Barcode.create(
        barcode_number: "12345678",
        item_code: "test_code1"
      )

      Barcode.create(
        barcode_number: "22345678",
        item_code: "test_code1"
      )

      Barcode.create(
        barcode_number: "32345678",
        item_code: "test_code1"
      )

      get "/barcodes"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["barcodes"].length).to eq(Barcode.count)
    end
  end

  describe "POST/create"do
    it 'barcode作成' do
      #紐付け用item
      item = Item.create(
        item_code: "test_code1",
        item_name: "test_name1",
        inspection: true,
        creation_unit: 1
      )
      
      create_params = {
        barcode: {
          barcode_number: 00000001,
          item_code: item[:item_code]
        }
      }

      count = Barcode.count
      post "/barcodes", params: create_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Barcode.count).to eq(count + 1)
    end
  end
end
