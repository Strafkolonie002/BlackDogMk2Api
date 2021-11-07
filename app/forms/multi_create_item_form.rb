class MultiCreateItemForm
  include Virtus.model
  include ActiveModel::Model

  attribute :items, Array

  validates :items, presence: true
  validates_with MultiCreateItemValidator

  def create
    response = []

    Item.transaction do
      items.each { |i|
        item = Item.create(
          item_code: i[:item_code],
          item_name: i[:item_name],
          # inspectionは未使用属性
          inspection: true,
          creation_unit: i[:creation_unit]
        )

        barcode_list = []

        i[:barcodes].each { |barcode|
          barcode = Barcode.create(
            barcode_number: barcode,
            item_code: item.item_code,
            item_id: item.id
          )
          barcode_hash = {
            barcode_number: barcode.barcode_number,
            item_code: item.item_code,
            item_id: item.id
          }
          barcode_list.push(barcode_hash)
        }

        item_hash = {
          id: item.id,
          item_code: item.item_code,
          item_name: item.item_name,
          inspection: true,
          creation_unit: item.creation_unit,
          barcodes: barcode_list,
          created_at: item.created_at,
          updated_at: item.updated_at
        }

        response.push(item_hash)
      }
    end

    response
  end

  def validate
    self.valid?
    self.errors
  end
end

