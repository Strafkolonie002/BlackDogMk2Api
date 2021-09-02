class Task < ApplicationRecord

  validates :task_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :task_name, presence: true, length: { maximum: 20 }
  validates :search_properties, presence: true, length: { maximum: 20 }
  validates :dest_material_state_code, length: {maximum: 20}

  def execute_task(params)
    materials = []

    # get Materials by the values of search_conditions
    params[:search_conditions].each do |key, value|
      materials = materials + Material.where("#{key}": value)
    end
  
    # update material_state_code, so do the properties if @task has task_details
    task_details = TaskDetail.where(task_code: self.task_code).order(:task_detail_number)

    # create hash for updating material_properties
    properties_hash = {}

    unless task_details.blank?
      task_details.each do |d|
        properties_hash[d.material_property_name] = params[:data].find { |single| 
          single[:task_detail_number].include?(d.task_detail_number)
        }[:value]
      end
    end

    # return value is array of Materials
    return_materials = []

    # update Materials
    materials.each do |single|
      container_code = params[:container_code]

      if params[:container_code].blank?
        container_code = single.container_code
      end

      material_properties = single.material_properties.merge(properties_hash)
      updated_material = Material.update(single.id, material_state_code: self.dest_material_state_code, container_code: container_code, material_properties: material_properties)
      return_materials.push(updated_material)
    end

    # post_action start
    return return_materials
  end

  def validate_execute_request(params)
    errors = []

    # validate the type of container_code if exists
    if !params[:container_code].blank? && !params[:container_code].is_a?(String)
      errors.push({ error_info: ["container_code should be String"] })
    end

    # validate conditions
    if params[:search_conditions].blank?
      errors.push({ error_info: ["search_conditions is required"] })
    end

    unless params[:search_conditions].blank?
      error_info = []

      # to validate the type, cast ActionController::Parameter to Hash
      begin 
        search_conditions = params[:search_conditions].permit!.to_hash
      rescue => error
        errors.push({ error_info: ["search_condition should be Hash"] })
        return errors
      end

      search_conditions.each do |key, value|
        unless self.search_properties.include?(key)
          error_info.push("#{key} is not included in search_properties of task:#{params[:task_code]}")
        end
      end

      unless error_info.blank?
        errors.push({ error_info: error_info })
      end
    end

    # validate deatails
    unless params[:data].blank?
      begin 
        params[:data].to_a
      rescue => error
        errors.push({ error_info: ["data should be Array"] })
        return errors
      end

      params[:data].each_with_index do |single, index|
        error_hash = {}
        error_info = []
  
        puts "#{single[:task_detail_number]}"
        puts "#{single[:value]}"

        puts single[:task_detail_number].blank?
        puts single[:task_detail_number].is_a?(Integer)

        if !single[:task_detail_number].blank? && !single[:task_detail_number].is_a?(Integer)
          error_info.push("task_detail_number should be Integer")
        else
          @task_detail = TaskDetail.find_by(task_code: params[:task_code], task_detail_number: single[:task_detail_number])
          error_info.push("TaskDetail not found by task_code:#{params[:task_code]}, task_detail_number:#{single[:task_detail_number]}") if @task_detail.nil?
        end

        if single[:value].blank?
          error_info.push("value is required if Task has TaskDetail")
        end
  
        unless error_info.blank?
          error_hash[:data_index] = index
          error_hash[:error_info] = error_info
          error_hash[:item] = single
          errors.push(error_hash)
        end
      end
    end

    return errors
  end

end
