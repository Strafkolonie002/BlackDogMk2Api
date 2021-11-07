require 'rails_helper'

RSpec.describe "Materials", type: :request do

  describe "GET /index" do
    it 'material全取得' do
      FactoryBot.create_list(:material, 10)
      get "/materials"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["materials"].length).to eq(Material.count)
    end
  end
end
