class StockMaterialForm
  include Virtus.model
  include ActiveModel::Model

  attribute :slip_number, String
  attribute :barcode_number, String
  attribute :container_code, String
  validates :barcode_number, presence: true
  validates :container_code, presence: true
  validates_with ContainerValidator
  validates_with StockMaterialValidator

  def stock
    # マスタ情報取得
    barcode = Barcode.find_by(barcode_number: self.barcode_number)
    container = Container.find_by(container_code: self.container_code)

    # order, order_details, materials取得
    order = Order.includes(order_details: :receive_order_detail_materials).find_by(slip_number: self.slip_number)

    materials = []
    order.order_details.each { |od|
      materials += od.receive_order_detail_materials
    }

    # バーコードからマテリアルを抽出
    selected_materials = materials.select { |m| m[:item_id] == barcode[:item_id] && m[:material_status] == "created" }

    # マテリアルをコンテナに格納
    result_flag = selected_materials.first.update(material_status: "stocked", container_id: container[:id])

    # orderのマテリアルが全て格納されていたらorderのステータスをstockedに変更
    update_order_status(order, materials) if result_flag == true

    result_flag
  end

  def validate
    self.valid?
    self.errors
  end

  def update_order_status(order, materials)
    material_statuses= []

    materials.each { |m|
      material_statuses.push(m[:material_status])
    }     
    
    order_stocked_flag = true
    material_statuses.each { |ms|
      order_stocked_flag = false unless ms == "stocked"
    }
    
    order.update(order_status: "stocked") if order_stocked_flag == true
  end
end