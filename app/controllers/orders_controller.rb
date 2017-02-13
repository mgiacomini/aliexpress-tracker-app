class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(order_params)
    render nothing: true, status: :ok
  end

  private
  def order_params
    params.permit(:aliexpress_number, :wordpress_reference, wordpress: [:consumer_secret, :consumer_key, :url], aliexpress: [:email, :password]).as_json
  end

end