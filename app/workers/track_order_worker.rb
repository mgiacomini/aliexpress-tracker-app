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

  def perform(params={})
    params = format_params(params)
    aliexpress_number = params[:aliexpress_number]
    wordpress_reference = params[:wordpress_reference]
    wordpress = Wordpress.new(params[:wordpress])
    aliexpress = ::AliexpressModel.new(params[:aliexpress])
    order = Order.new(aliexpress: aliexpress, aliexpress_number: aliexpress_number, wordpress: wordpress, wordpress_reference: wordpress_reference)

    browser = Aliexpress::BrowserBuilder.build
    tracking_service = Aliexpress::Tracker.new(order, browser, NullableLog.new)
    tracking_service.track!
    browser.close
  end

  def format_params(hash)
    output = hash.dup
    output[:aliexpress_number] = cleanup(output[:aliexpress_number])
    output[:wordpress_reference] = cleanup(output[:wordpress_reference])
    output[:wordpress] = cleanup(output[:wordpress_reference])
    output[:aliexpress] = cleanup(output[:wordpress_reference])
    output
  end

end