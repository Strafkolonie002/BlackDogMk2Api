class MoveMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :barcode_number, String
  attribute :from_container_code, String
  attribute :to_container_code, String
  validates :barcode_number, presence: true
  validates :from_container_code, presence: true
  validates :to_container_code, presence: true
  validates_with BarcodeNumberValidator
  validates_with MoveMaterialValidator

  def move
    barcode = Barcode.find_by(barcode_number: self.barcode_number )
    from_container = Container.includes(:materials).find_by(container_code: self.from_container_code)
    to_container = Container.find_by(container_code: self.to_container_code)
    from_container.materials.find{|m| m.item_id == barcode[:item_id]}.update(container_id: to_container.id)
  end

  def validate
    self.valid?
    self.errors
  end
end