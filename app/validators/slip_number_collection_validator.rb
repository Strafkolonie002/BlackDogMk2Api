class SlipNumberCollectionValidator < ActiveModel::Validator
  def validate(record)
    slip_list = []
    record.orders.each do |order|
      if slip_list.include?(order.slip_number)
        record.errors[:slip_number] << "slip_number: #{order.slip_number} duplicates in orders "
      else
        slip_list.push(order.slip_number)
      end
    end
  end
end