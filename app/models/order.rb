class Order
  include ActiveModel::Model
  attr_accessor :aliexpress, :aliexpress_number, :wordpress, :wordpress_reference, :tracking_number, :success_url

  def notify_client
    wordpress.update_tracking_number_note({'id' => wordpress_reference}, aliexpress_number)
    send_success_notification unless success_url.blank?
  end

  def tracked?
    true if !tracking_number.blank?
  end

  private

  def send_success_notification
    success_params = {tracking_number: tracking_number, wordpress_reference: wordpress_reference, aliexpress_number: aliexpress_number}
    Excon.post(success_url,
               body: URI.encode_www_form(success_params),
               headers: {'Content-Type' => 'application/x-www-form-urlencoded'})
  end
end