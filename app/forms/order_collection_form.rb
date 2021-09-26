class OrderCollectionForm
  include Virtus.model
  include ActiveModel::Model

  attribute :orders, Array[OrderForm]

  validates :orders, presence: true
  validates_with SlipNumberCollectionValidator

  # order, order_detail, materialを生成
  def create_receive_order
    order_list = []

    Order.transaction do
      orders.each do |o|
        order = Order.create(
          slip_number: o[:slip_number],
          order_type: "receive",
          order_status: "created",
          order_info: o[:order_info]
        )

        o[:order_details].each do |od|
          item = Item.find_by(item_code: od[:item_code])
          order_detail = order.order_details.create(
            item_id: item[:id],
            quantity: od[:quantity]
          )
    
          (od[:quantity] * item[:creation_unit]).times do
            material = order_detail.materials.create(
              item_id: item[:id],
              material_status: "created"
            )
          end
        end

        order_list.push(order)
      end
    end

    order_list
  end

  # order, order_detailを作成、materialのステータスをallocatedに変更
  # 欠品した場合はorderのステータスをshortageに変更
  def create_ship_order
    order_list = []
    Order.transaction do
      orders.each do |o|
        order = Order.create(
          slip_number: o[:slip_number],
          order_type: "ship",
          order_status: "created",
          order_info: o[:order_info]
        )

        o[:order_details].each do |od|
          item = Item.find_by(item_code: od[:item_code])
          order_detail = order.order_details.create(
            item_id: item[:id],
            quantity: od[:quantity]
          )

          if od[:quantity] > Material.where(item_code: od[:item_code], material_status: "stocked").count
            Order.find(order.id).update(order_status: "shortage")
          else
            materials = Material.where(item_code: od[:item_code], material_status: "stocked").limit(od[:quantity])
            materials.update(material_status: "allocated")
          end

        end

        order_list.push(order)
      end
    end
  end

  # orders, order, order_detail の順にバリデーションでエラーにする
  # どのorderのどのorder_detaolでエラーが出たのかを明確にするため、通常のバリデーションと異なるレスポンスにしている
  def validate_params
    error_list = []
    slip_number_list = []

    orders_errors = validate_orders_collection
    
    if orders_errors.blank?
      # order validate
      self.orders.each_with_index do |order_form, order_index|

        order_form_errors = validate_order_form(order_form)

        if order_form_errors.blank?
          # order_detail error作成用
          order_details_error_list = []
          order_error_hash = {
            orders_index: order_index,
            order: order_form,
            order_errors: order_details_error_list
          }

          # order detail validate
          order_form[:order_details].each_with_index do |order_detail_form, order_detail_index|
            order_detail_form_errors = validate_order_detail_form(order_detail_form)

            order_detail_error_hash = {
              order_details_index: order_detail_index,
              order_detail_errors: order_detail_form_errors
            }

            # Itemが見つからない場合もエラー
            item = Item.find_by(item_code: order_detail_form[:item_code])

            if item.blank?
              item_error_hash = {
                item_code: [
                  "item not found by #{order_detail_form[:item_code]}"
                ]
              }
              order_detail_error_hash[:item_error] = item_error_hash
            end

            # order_details_error_listにorder_detailのエラーを格納
            if !order_detail_form_errors.blank? || item.blank?
              order_details_error_list.push(order_detail_error_hash)
            end
          end

          # order detail errorを格納するリストが空でない場合はorder errorを格納
          unless order_details_error_list.blank?
            error_list.push(order_error_hash)
          end
        
        # order errorがある場合はorder errorを格納
        else
          order_error_hash = {
            orders_index: order_index,
            order: order_form,
            order_errors: order_form_errors
          }
          error_list.push(order_error_hash)
        end
      end
    else
      # orders errorがある場合はorders errorを格納
      error_list.push(orders_errors)
    end

    error_list
  end

  def validate_orders_collection
    self.valid?
    self.errors
  end

  def validate_order_form(order_form)
    order_form.valid?
    order_form.errors
  end

  
  def validate_order_detail_form(order_detail_form)
    order_detail_form.valid?
    order_detail_form.errors
  end

end

