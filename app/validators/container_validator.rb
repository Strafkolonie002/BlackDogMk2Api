class ContainerValidator < ActiveModel::Validator
  def validate(record)
    if Container.find_by(container_code: record.container_code).blank?
      record.errors[:container] << "Container not found"
    end
  end
end