require 'aliexpress/auth'
require 'aliexpress/browser_builder'
require 'aliexpress/tracker'
require 'aliexpress/url_builder'

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
  sidekiq_options retry: 10

  def perform(params={})
    # check if order already exists
    existing_order = Order.find_by(aliexpress_number: aliexpress_number(params))
    return existing_order.notify_client if existing_order.tracked?

    browser = ::Aliexpress::BrowserBuilder.build
    order = build_order(params)
    tracking_service = ::Aliexpress::Tracker.new(order, browser, NullableLog.new)
    tracking_service.track!
    browser.close
  end

  def build_order(params={})
    success_url = params[:success_url] || params['success_url']
    wordpress_reference = params[:wordpress_reference] || params['wordpress_reference']
    wordpress = ::Wordpress.new(params[:wordpress] || params['wordpress'])
    aliexpress = ::AliexpressModel.new(params[:aliexpress] || params['aliexpress'])
    ::Order.new(success_url: success_url, aliexpress: aliexpress, aliexpress_number: aliexpress_number(params), wordpress: wordpress, wordpress_reference: wordpress_reference)
  end

  def aliexpress_number(params={})
    params[:aliexpress_number] || params['aliexpress_number']
  end

end