FactoryBot.define do
  factory :barcode do
    association :item, factory: :item
    sequence(:barcode_number) { |n| "TEST_NUMBER#{n}" }
    sequence(:item_code) { |n| "TEST_CODE#{n}"  }
  end
end
