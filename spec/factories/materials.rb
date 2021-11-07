FactoryBot.define do
  factory :material do
    association :item, factory: :item
    association :receive_order_detail, factory: :order_detail
    association :ship_order_detail, factory: :order_detail
    material_status { "created" }
  end
end
