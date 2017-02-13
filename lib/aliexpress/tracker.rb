module Aliexpress
  class Tracker
    attr_reader :aliexpress, :browser, :log, :order

    def initialize(order, browser, logger)
      @order = order
      @aliexpress = order.aliexpress
      @browser = browser
      @log = logger
    end

    def track!
      puts "========= Authenticate user for track an order"

      login
      open_order_page order.aliexpress_number
      sleep 5

      shipping_container = @browser.element(:id, 'J_ContentOfPackageDetail').wait_until_present
      if shipping_container.exists?
        shipping_details_container = shipping_container.div(class: 'consignment-detail-content').wait_until_present
        tracking_number = shipping_details_container.div(class: 'msg').wait_until_present
        tracking_number = tracking_number.text
        if !tracking_number.blank?
          puts "========= Order already shipped: Getting tracking number #{tracking_number}"
          @log.add_message('Atualizando wordpress com código de rastreio do pedido '+ tracking_number)
          order.notify_client
          return tracking_number
        else
          puts "========= Order not shipped yet: order number #{order.aliexpress_number}"
          @log.add_message('Não foi possível rastrear o pedido '+ order.aliexpress_number)
        end
      end
    rescue ::Watir::Wait::TimeoutError
      puts "========= Order not shipped yet: order number #{order.aliexpress_number}"
      @log.add_message('Não foi possível rastrear o pedido '+ order.aliexpress_number)
    end

    private
    def login
      ::Aliexpress::Auth.new(aliexpress, browser, log).login
    end

    def build_order_url(order_number)
      ::Aliexpress::UrlBuilder.logisticsdetail order_number
    end

    def open_order_page(order_number)
      @browser.goto build_order_url(order_number)
    end
  end
end