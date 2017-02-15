require 'woocommerce_api'

class Wordpress
  include ActiveModel::Model
  attr_accessor :url, :consumer_key, :consumer_secret
  validates_presence_of :url, :consumer_key, :consumer_secret

  @error = nil

  def error
    @error
  end

  def woocommerce
    woocommerce = WooCommerce::API.new(
        self.url,
        self.consumer_key,
        self.consumer_secret,
        {
            wp_api: true,
            version: "wc/v1"
        }
    )
    woocommerce
  end

  def update_tracking_number_note order, tracking_number
    data = {note: "Código de rastreio: #{tracking_number}"}
    woocommerce.post("orders/#{order["id"]}/notes", data).parsed_response
  end

end