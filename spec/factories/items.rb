FactoryBot.define do
  factory :item do
    sequence(:item_code) { |n| "TEST_CODE#{n}"}
    sequence(:item_name) { |n| "TEST_NAME#{n}"}
    inspection { true }
    creation_unit { 1 }
  end
end
