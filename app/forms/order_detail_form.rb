class OrderDetailForm
  include Virtus.model
  include ActiveModel::Model

  attribute :item_code, String
  attribute :quantity, Integer

  validates :item_code, presence: true
  validates :quantity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 1 }
end