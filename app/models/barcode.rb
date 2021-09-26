class Barcode < ApplicationRecord
  belongs_to :item

  validates :barcode_number, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :item_code, presence: true, length: { maximum: 20 }
  validates :item_id, presence: true
  validates_with ItemValidator
end
