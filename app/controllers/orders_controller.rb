class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(params[:aliexpress], params[:wordpress], params[:aliexpress_number], params[:wordpress_reference])
    respond_with nil
  end

end