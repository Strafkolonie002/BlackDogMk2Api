class Material < ApplicationRecord
  
  validates :item_code, presence: true, length: { maximum: 20 }
  validates :material_state_code, presence: true, length: { maximum: 20 }
  validates :material_properties, presence: true

  def self.bulk_insert(params)
    material_data = []

    params[:data].each do |single|
      material_properties = single[:material_properties]

      if material_properties.blank?
        material_properties = {}
      end

      single[:quantity].to_i.times {
        material_params = {
          item_code: single[:item_code],
          material_state_code: params[:material_state_code],
          material_properties: material_properties,
          created_at: Time.current,
          updated_at: Time.current
        }
        material_data.push(material_params)
      }
    end
    Material.insert_all(material_data, returning: %i[id item_code material_state_code material_properties])
  end

  def self.bulk_update_material_state(params)
    target_materials = []

    params[:data].each do |single|
      material_properties = single[:material_properties]

      if material_properties.blank?
        material_properties = {}
      end

      materials = Material.where(
        item_code: single[:item_code], 
        material_state_code: params[:material_state_code]
      ).order(:id).limit(single[:quantity])
      materials.update_all(material_state_code: params[:dest_material_state_code], updated_at: Time.now)

      target_materials = target_materials + materials
    end

    return target_materials
  end

  def self.allocatable?(item_code, material_state_code, quantity)
    count = Material.where(item_code: item_code, material_state_code: material_state_code).count
    if count >= quantity
      return true
    else
      return false
    end
  end

  def self.validate_create_materials_request(params)
    errors = []

    # validate material_state_code
    if params[:material_state_code].blank?
      errors.push({ error_info: ["material_state_code is required"] })
      return errors
    elsif !params[:material_state_code].is_a?(String)
      errors.push({ error_info: ["material_state_code should be String"] })
      return errors
    else
      @material_state = MaterialState.find_by(material_state_code: params[:material_state_code])
      errors.push({ error_info: ["MaterialState not found"] }) if @material_state.nil?
    end

    # validate data
    if params[:data].blank?
      errors.push({ error_info: ["data is required"] })
      return errors
    else
      begin 
        params[:data].to_a
      rescue => error
        errors.push({ error_info: ["data should be Array"] })
        return errors
      end
    end

    # validate the condition of creating Material
    params[:data].each_with_index do |single, index|
      error_hash = {}
      error_info = []

      if single[:item_code].blank?
        error_info.push("item_code is required")
      elsif !single[:item_code].is_a?(String)
        error_info.push("item_code should be String")
      else
        @item = Item.find_by(item_code: single[:item_code])
        error_info.push("Item not found") if @item.nil?
      end

      if single[:quantity].blank?
        error_info.push("quantity is required")
      elsif !single[:quantity].is_a?(Integer)
        error_info.push("quantity should be Integer")
      else
        error_info.push("set quantity greater than 0") if 0 >= single[:quantity] 
      end
      
      unless single[:material_properties].nil?
        # to validate the type, casts ActionController::Parameter to Hash
        begin 
          material_properties = single[:material_properties].permit!.to_hash
        rescue => error
          error_info.push("material_properties should be Hash")
        end
      end

      unless error_info.blank?
        error_hash[:data_index] = index
        error_hash[:error_info] = error_info
        error_hash[:order] = single
        errors.push(error_hash)
      end
    end

    return errors
  end

  def self.validate_update_materials(params)
    errors = []

    # validate material_state_code
    if params[:material_state_code].blank?
      errors.push({ error_info: ["material_state_code is required"] })
      return errors
    elsif !params[:material_state_code].is_a?(String)
      errors.push({ error_info: ["material_state_code should be String"] })
      return errors
    else
      @material_state = MaterialState.find_by(material_state_code: params[:material_state_code])
      errors.push({ error_info: ["MaterialState not found by material_state_code"] }) if @material_state.nil?
    end

    if params[:dest_material_state_code].blank?
      errors.push({ error_info: ["dest_material_state_code is required"] })
      return errors
    elsif !params[:dest_material_state_code].is_a?(String)
      errors.push({ error_info: ["dest_material_state_code should be String"] })
      return errors
    else
      @material_state = MaterialState.find_by(material_state_code: params[:dest_material_state_code])
      errors.push({ error_info: ["MaterialState not found by dest_material_state_code"] }) if @material_state.nil?
    end

    # validate data
    if params[:data].blank?
      errors.push({ error_info: ["data is required"] })
      return errors
    else
      begin 
        params[:data].to_a
      rescue => error
        errors.push({ error_info: ["data should be Array"] })
        return errors
      end
    end

    # validate the condition of updating Material
    params[:data].each_with_index do |single, index|
      error_hash = {}
      error_info = []

      if single[:item_code].blank?
        error_info.push("item_code is required")
      elsif !single[:item_code].is_a?(String)
        error_info.push("item_code should be String")
      else
        @item = Item.find_by(item_code: single[:item_code])
        error_info.push("Item not found") if @item.nil?
      end

      if single[:quantity].blank?
        error_info.push("quantity is required")
      elsif !single[:quantity].is_a?(Integer)
        error_info.push("quantity should be Integer")
      else
        error_info.push("set quantity greater than 0") if 0 >= single[:quantity] 
      end

      unless Material.allocatable?(single[:item_code], params[:material_state_code], single[:quantity])
        error_info.push("Material Shortage!")
      end

      unless error_info.blank?
        error_hash[:data_index] = index
        error_hash[:error_info] = error_info
        error_hash[:order] = single
        errors.push(error_hash)
      end
    end

    return errors
  end

  def self.add_time_and_properties(data)
    data.each do |single|
      # set material_properties as {}, when null
      single[:material_properties] = {} if single[:material_properties].blank?
      single[:created_at] = Time.now
      single[:updated_at] = Time.now
    end

    return data
  end

end
