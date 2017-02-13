require 'woocommerce_api'

class Wordpress
  include ActiveModel::Model
  attr_accessor :url, :consumer_key, :consumer_secret

  @error = nil

  def error
    @error
  end

  def woocommerce
    woocommerce = WooCommerce::API.new(
        self.url, #Url do site
        self.consumer_key, #Consumer Key
        self.consumer_secret, #Consumer Secret
        {
            wp_api: true,
            version: "wc/v1" #Versão da API
        }
    )
    woocommerce
  end

  def update_tracking_number_note order, tracking_number
    #Atualiza o código de rastreio do pedido
    data = {note: "Código de rastreio: #{tracking_number}"}
    #POST em order notes
    woocommerce.post("orders/#{order["id"]}/notes", data).parsed_response
  end

end