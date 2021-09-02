class Item < ApplicationRecord

  validates :item_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :item_name, presence: true, length: { maximum: 20 }
  validates :item_properties, presence: true

  def self.validate_bulk_upsert_request(params)
    errors = []

    # data validate
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

    # Item validate
    params[:data].each_with_index do |single, index|
      error_hash = {}
      error_info = []

      if single[:item_code].blank?
        error_info.push("item_code is required")
      else
        unless single[:item_code].is_a?(String)
          error_info.push("item_code should be String")
        end
      end

      if single[:item_name].blank?
        error_info.push("item_name is required")
      else
        unless single[:item_name].is_a?(String)
          error_info.push("item_name should be String")
        end
      end

      unless single[:item_properties].blank?
        # to validate the type, cast ActionController::Parameter to Hash
        begin 
          item_properties = single[:item_properties].permit!.to_hash
        rescue => error
          error_info.push("item_properties should be Hash")
        end
      end

      unless error_info.blank?
        error_hash[:data_index] = index
        error_hash[:error_info] = error_info
        error_hash[:item] = single
        errors.push(error_hash)
      end
    end

    return errors
  end

  def self.add_time_and_properties(data)
    data.each do |single|
      # set item_properties as {}, when null
      single[:item_properties] = {} if single[:item_properties].blank?
      single[:created_at] = Time.now
      single[:updated_at] = Time.now
    end

    return data
  end

end
