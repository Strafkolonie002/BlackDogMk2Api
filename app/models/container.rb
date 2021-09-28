class Container < ApplicationRecord
  has_many :materials

  validates :container_code, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :container_type, length: { maximum: 20 }
end
