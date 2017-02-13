class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(order_params)
    render nothing: true, status: :ok
  end

  private
  def order_params
    params.permit!.as_json
  end

end