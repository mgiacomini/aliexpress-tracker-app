class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(order_params.to_h)
    head :ok
  end

  private

  def order_params
    params.require(:order).permit(:aliexpress_number, :wordpress_reference, :success_url,
                  wordpress: [:url, :consumer_key, :consumer_secret],
                  aliexpress: [:email, :password])
  end

end