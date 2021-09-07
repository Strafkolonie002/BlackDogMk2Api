class PostAction < ApplicationRecord
  validates :post_action_code, presence: true, length: { maximum: 20 }
  validates :post_action_name, presence: true, length: { maximum: 20 }
  validates :method_name, presence: true, length: { maximum: 40 }

  # !!CAUTION!! the params of the methods is only materials that updated by Task

  def self.hello(materials)
    return "hello world"
  end

  def self.material_ids(materials)
    result = []
    materials.each do |single|
      result.push(single[:id])
    end
    return result
  end
    
end
