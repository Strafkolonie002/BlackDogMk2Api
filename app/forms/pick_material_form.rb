class PickMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :barcode_number, String
  attribute :container_code, String
  validates :slip_number, presence: true
  validates :barcode_number, presence: true
  validates :container_code, presence: true
  validates_with BarcodeNumberValidator
  validates_with ContainerValidator
  validates_with PickMaterialValidator

  def pick
    # マスタ情報取得
    barcode = Barcode.find_by(barcode_number: self.barcode_number)
    container = Container.find_by(container_code: self.container_code)

    # order, order_details, materials取得
    order = Order.includes(order_details: :ship_order_detail_materials).find_by(slip_number: self.slip_number)

    materials = []
    order.order_details.each { |od|
      materials += od.ship_order_detail_materials
    }

    # バーコードからマテリアルを抽出
    materials.select! { |m| m[:item_id] == barcode[:item_id] && m[:material_status] == "allocated" }

    puts "pinopai #{materials}"

    # マテリアルをコンテナからピック
    result_flag = materials.first.update(material_status: "picked", container_id: container[:id])

    # orderのマテリアルが全て格納されていたらorderのステータスをpickedに変更
    update_order_status(order, materials) if result_flag == true

    result_flag
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
    
    order_picked_flag = true
    material_status_list.each do |ms|
      order_picked_flag = false unless ms == "picked"
    end
    
    order.update(order_status: "picked") if order_picked_flag == true
  end
end