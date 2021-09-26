class StockMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :barcode_number, String
  attribute :container_code, String
  validates :barcode_number, presence: true
  validates :container_code, presence: true
#  validates_with ExistsSlipNumberValidator
  validates_with BarcodeNumberValidator
  validates_with StockMaterialValidator
  validates_with ContainerValidator

  def stock
    order = Order.find_by(slip_number: self.slip_number)
    barcode = Barcode.find_by(barcode_number: self.barcode_number)
    container = Container.find_by(container_code: self.container_code)
    materials = find_materials(order)
    to_stock_materials = materials.select { |m| m[:item_id] = barcode[:item_id] }
    flag = to_stock_materials[0].update(material_status: "stocked", container_id: container[:id])
    update_order_status(order, materials)
    return flag
  end

  def find_materials(order)
    order_details = OrderDetail.where(order_id: order[:id])
    material_list = []
    order_details.each do |od|
      materials = Material.where(order_detail_id: od[:id])
      material_list = material_list + materials
    end
    material_list
  end

  def validate
    self.valid?
    self.errors
  end

  def update_order_status(order, materials)
    material_status_list= []

    materials.each do |m|
      material_status_list.push(m[:material_status])
    end      
    
    order_stocked_flag = true
    material_status_list.each do |ms|
      order_stocked_flag = false unless ms == "stocked"
    end
    
    order.update(order_status: "stocked") if order_stocked_flag == true
  end
end