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
    browser = ::Aliexpress::BrowserBuilder.build
    tracking_service = ::Aliexpress::Tracker.new(build_order(params), browser, NullableLog.new)
    tracking_service.track!
    browser.close
  end

  def build_order(params={})
    aliexpress_number = params[:aliexpress_number] || params['aliexpress_number']
    wordpress_reference = params[:wordpress_reference] || params['wordpress_reference']
    wordpress = ::Wordpress.new(params[:wordpress] || params['wordpress'])
    aliexpress = ::AliexpressModel.new(params[:aliexpress] || params['aliexpress'])
    ::Order.new(aliexpress: aliexpress, aliexpress_number: aliexpress_number, wordpress: wordpress, wordpress_reference: wordpress_reference)
  end

  def order_params(hash)
    hash
  end

end