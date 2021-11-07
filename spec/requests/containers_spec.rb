require 'rails_helper'

RSpec.describe "Containers", type: :request do
  describe "GET /index" do
    it 'container全取得' do
      FactoryBot.create_list(:container, 10)
      get "/containers"
      json = JSON.parse(response.body)
      expect(response.status).to eq(200)
      expect(json["containers"].length).to eq(Container.count) 
    end
  end

  describe "POST /create" do
    it 'container作成' do
      create_params = {
        container: {
          container_code: "test",
          container_type: "Pick"
        }
      }

      count = Container.count
      post "/containers", params: create_params
      expect(response.status).to eq(200)
      expect(Container.count).to eq(count + 1)
    end
  end
end
