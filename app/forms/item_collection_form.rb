class ItemCollectionForm
  include Virtus.model
  include ActiveModel::Model

  attribute :item, Array[Item]

  validates :item, presence: true

  def save!
    return false if invalid?
    puts "pinoman #{items}"
    Item.transaction do
      self.items.map do |item|
        item.save!
      end
    end
      return true
    rescue => e
      return false
  end
end
