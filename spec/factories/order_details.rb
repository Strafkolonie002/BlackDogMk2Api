FactoryBot.define do
  factory :order_detail do
    order_id { "" }
    item_code { "MyString" }
    quantity { 1 }
    order_detail_info { "" }
  end
end
