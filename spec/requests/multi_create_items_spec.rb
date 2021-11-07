require 'rails_helper'

RSpec.describe "MultiCreateItems", type: :request do
  describe "POST /index" do
    it 'itemとbarcodeを同時に複数作成' do
      create_params = {
        multi_create_item: {
          items: [
            {
              item_code: "mci_spec1_code",
              item_name: "mci_spec1_name",
              creation_unit: 1,
              barcodes: [
                "mci_spec1_bn1",
                "mci_spec1_bn2"
              ]
            },
            {
              item_code: "mci_spec2_code",
              item_name: "mci_spec2_name",
              creation_unit: 1,
              barcodes: [
                "mci_spec1_bn3",
                "mci_spec1_bn4"
              ]
            }
          ]
        }
      }

      item_count = Item.count
      barcode_count = Barcode.count
      post "/multi_create_items", params: create_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Item.count).to eq(item_count + create_params[:multi_create_item][:items].length)
    end
  end
end
