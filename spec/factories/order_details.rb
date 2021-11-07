FactoryBot.define do
  factory :order_detail do
    association :order, factory: :order
    association :item, factory: :item
    quantity { 1 }
  end
end
