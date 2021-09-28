class ShipMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :container_code, String
  validates :slip_number, presence: true
  validates :container_code, presence: true
  validates_with ContainerValidator
  validates_with ShipMaterialValidator
  def ship

    order = Order.find_by(slip_number: self.slip_number)

    # container, materisls取得
    container = Container.includes(:materials).find_by(container_code: self.container_code)

    # マテリアルを出荷
    updated_materials = container.materials.update_all(material_status: "shipped", container_id: nil)

    puts "pinopai #{updated_materials}"

    # orderのマテリアルが全て出荷されていたらorderのステータスをpickedに変更
    update_order_status(order, container.materials) unless updated_materials.blank?

    updated_materials
  end

  def validate
    self.valid?
    self.errors
  end

  def update_order_status(order, materials)
    material_status_list = []

    materials.each do |m|
      material_status_list.push(m[:material_status])
    end      
    
    order_shipped_flag = true
    material_status_list.each do |ms|
      order_shiped_flag = false unless ms == "shipped"
    end
    
    order.update!(order_status: "shipped") if order_shipped_flag == true
  end
end