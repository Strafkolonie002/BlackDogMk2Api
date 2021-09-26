class SlipNumberValidator < ActiveModel::Validator
  def validate(record)
    unless Order.find_by(slip_number: record.slip_number).blank?
      record.errors[:slip_number] << "slip_number: #{record.slip_number} already exists"
    end
  end
end