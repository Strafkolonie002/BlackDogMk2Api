class Item < ApplicationRecord
  def self.validate_create(params)
    errors = []

    # Exists data array?
    if params[:data].blank?
      errors.push({ error_info: ["data is required"] })
    else
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

        unless single[:item_properties].nil?
          # to validate the type, casts ActionController::Parameter to Hash
          begin 
            item_properties = single[:item_properties].permit!.to_hash
          rescue => error
            error_info.push("item_properties should be Hash")
            error_info.push("the type of item_properties error => #{error}")
          end
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
