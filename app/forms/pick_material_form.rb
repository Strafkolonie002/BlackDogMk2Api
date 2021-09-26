class StockMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute slip_number, String
  validates :slip_number, presence: true

  def validate
    self.valid?
    self.errors
  end
end