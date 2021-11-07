FactoryBot.define do
  factory :container do
    sequence(:container_code) { |n| "TEST_CODE#{n}" }
    container_type { "Stock" }
  end
end
