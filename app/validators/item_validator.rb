class ItemValidator < ActiveModel::Validator
  def validate(record)
    if Item.find_by(item_code: record.item_code).blank?
      record.errors[:item] << "Item not found"
    end
  end
end