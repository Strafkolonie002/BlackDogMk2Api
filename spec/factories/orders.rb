FactoryBot.define do
  factory :order do
    sequence(:slip_number) { |n| "TEST_NUMBER#{n}" }
    order_status { "created" }
    order_type { "receive" } #デフォルト値
    order_info { { "testKey": "testValue" } }
  end
end
