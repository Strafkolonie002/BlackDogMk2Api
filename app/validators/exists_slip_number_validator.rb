class ExistsSlipNumberValidator < ActiveModel::Validator
  def validate(record)
    if Order.find_by(slip_number: record.slip_number).blank?
      record.errors[:slip_number] << "Order not found"
    end
  end
end