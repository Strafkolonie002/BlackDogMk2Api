require 'rails_helper'

RSpec.describe "MoveMaterials", type: :request do
  describe "POST /create" do
    it 'move stock' do
      from = FactoryBot.create(:container)
      to = FactoryBot.create(:container)
      item = FactoryBot.create(:item)
      barcode = FactoryBot.create(:barcode, item_id: item.id, item_code: item.item_code)
      material = FactoryBot.create(:material, material_status: "stocked", container_id: from.id, item_id: item.id)

      post_params = {
        move_material: {
          barcode_number: barcode.barcode_number,
          from_container_code: from.container_code,
          to_container_code: to.container_code
        }
      }

      post "/move_materials", params: post_params
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(Material.find(material.id).container_id).to eq(to.id)
    end
  end
end
