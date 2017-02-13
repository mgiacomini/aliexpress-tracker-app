class NullableLog
  def add_processed(message)
  end

  def add_message(message)
  end

  def get_message
  end
end

class TrackOrderWorker
  include Sidekiq::Worker

  def perform(aliexpress, wordpress, aliexpress_number, wordpress_reference)
    wordpress = Wordpress.new(wordpress)
    aliexpress = ::AliexpressModel.new(aliexpress)
    order = Order.new(aliexpress: aliexpress, aliexpress_number: aliexpress_number, wordpress: wordpress, wordpress_reference: wordpress_reference)

    browser = Aliexpress::BrowserBuilder.build
    tracking_service = Aliexpress::Tracker.new(order, browser, NullableLog.new)
    tracking_service.track!
    browser.close
  end
end