class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(params)
    respond_with nil
  end

end