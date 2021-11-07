class MultiCreateItemValidator < ActiveModel::Validator
  def validate(record)

    if record.items.blank?
      return record.errors[:barcodes] << "the column of items:[] is required"
    else
      record.items.each { |item|
        if item[:item_code].blank?
          return record.errors[:item_code] << "item_code is required"
        else
          unless Item.find_by(item_code: item[:item_code]).blank?
            return record.errors[:item_code] << "item_code:#{item[:item_code]} is already used"
          end
        end

        if item[:item_name].blank?
          return record.errors[:item_name] << "item_name is required"
        end

        if item[:creation_unit].blank?
          return record.errors[:creation_unit] << "creation_unit is required"
        end

        if item[:barcodes].blank?
          return record.errors[:barcodes] << "the column of barcodes:[] is required"
        else
          item[:barcodes].each { |b|
            if b.blank?
              return record.errors[:barcodes] << "barcode is required"
            else
              unless Barcode.find_by(barcode_number: b).blank?
                return record.errors[:barcodes] << "barcode_number:#{b} is already used"
              end
            end
          }
        end
      }
    end
  end
end