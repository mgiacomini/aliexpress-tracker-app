class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(params)
    render nothing: true, status: :ok
  end

end