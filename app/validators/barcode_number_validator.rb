class BarcodeNumberValidator < ActiveModel::Validator
  def validate(record)
    if Barcode.find_by(barcode_number: record.barcode_number).blank?
      record.errors[:barcode_number] << "Barcode not found"
    end
  end
end