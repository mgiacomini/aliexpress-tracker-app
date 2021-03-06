require 'faraday'

class Order
  include ActiveModel::Model
  attr_accessor :aliexpress, :aliexpress_number, :wordpress, :wordpress_reference, :tracking_number, :success_url

  def notify_client
    p "++++ Notificando Cliente: #{self.success_url} +++++"
    send_success_notification(self.success_url) unless self.success_url.blank?
  end

  def tracked?
    true unless tracking_number.blank?
  end

  private

  def send_success_notification(url)
    post_api_request url, success_params
  end

  def post_api_request(url, payload={})
    conn = Faraday.new(url: url)
    conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = payload.to_json
    end
  end

  def success_params
    {
        order: {
            tracking_number: tracking_number,
            wordpress_reference: wordpress_reference,
            aliexpress_number: aliexpress_number
        }
    }
  end

end