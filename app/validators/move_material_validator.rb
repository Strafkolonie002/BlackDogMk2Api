class MoveMaterialValidator < ActiveModel::Validator
  def validate(record)
    barcode = Barcode.includes(:item).find_by(barcode_number: record.barcode_number)
    from_container = Container.includes(:materials).find_by(container_code: record.from_container_code)
    if from_container.blank?
      return record.errors[:container] << "From Container not found"
    end

    if Container.find_by(container_code: record.to_container_code).blank?
      return record.errors[:container] << "To Container not found"
    end

    if from_container.materials.find{ |m| m.item_id == barcode.item_id}.blank?
      return record.errors[:material] << "No material in this container"
    end

  end
end