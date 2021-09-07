class Task < ApplicationRecord
  validates :task_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :task_name, presence: true, length: { maximum: 20 }
  validates :search_properties, presence: true, length: { maximum: 20 }
  validates :dest_material_state_code, length: {maximum: 20}
  validates :post_action_code, length: { maximum: 40 }

  def execute_task(params)

    result = {}
    
    # get Materials by the values of search_conditions
    materials = Material.where(params[:search_conditions])

    if materials.blank?
      result[:materials] = materials
      result[:post_action_result] = nil
      return  result
    end
  
    # update material_state_code, so do the properties if @task has task_details
    task_details = TaskDetail.where(task_code: self.task_code).order(:task_detail_number)

    # create hash for updating material_properties
    properties_hash = {}

    unless task_details.blank?
      task_details.each do |d|
        properties_hash[d.material_property_name] = params[:data].find { |single| 
          single[:task_detail_number] = d.task_detail_number
        }[:value]
      end
    end

    # update Materials
    updated_materials = Parallel.map(materials, in_thread: 5) do |single|
      container_code = params[:container_code]
      container_code = single.container_code if container_code.blank?

      material_properties = single.material_properties.merge(properties_hash)
      updated_material = Material.update(single.id, material_state_code: self.dest_material_state_code, container_code: container_code, material_properties: material_properties)
    end

    result[:materials] = updated_materials

    # post_action start
    @post_action = PostAction.find_by(post_action_code: self.post_action_code)

    if @post_action
      post_action_result = PostAction.send("#{@post_action.method_name}", updated_materials)
      result[:post_action_result] = post_action_result
    end

    return result
  end

  def validate_execute_request(params)
    errors = []

    # validate Container if exists
    if !params[:container_code].blank? && !params[:container_code].is_a?(String)
      errors.push({ error_info: ["container_code should be String"] })
    elsif !params[:container_code].blank?
      @container = Container.find_by(container_code: params[:container_code])
      errors.push({ error_info: ["Container not found"] }) if @container.nil?
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

      # params[:search_conditon] is Hash, but self.search_properties is Array
      self.search_properties.each do |single|
        unless search_conditions.has_key?(single)
          error_info.push("#{single} is not included in search_properties of task:#{params[:task_code]}")
        end
      end

      unless error_info.blank?
        errors.push({ error_info: error_info })
      end
    end

    # validate post_action
    unless params[:post_action_code].blank?
      errors.push({ error_info: ["post_action_code should be String"] }) if !params[:post_action_code].is_a?(String)
      @post_action = PostAction.find_by(post_action_code: params[:post_action_code])
      p "postactionName =  #{@post_action.post_action_name}"
      if @post_action.blank?
        errors.push({ error_info: ["PostAction not found"] })
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
      task_details = TaskDetail.where(task_code: params[:task_code])
      if params[:data].count != task_details.count
        errors.push({ error_info: ["TaskDetails is not correct", "TaskDetails of Task:#{params[:task_code]} is #{task_details.each do |d| p d end}", "TaskDetails" => params[:data]] })
        return errors
      end

      params[:data].each_with_index do |single, index|
        error_hash = {}
        error_info = []

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
