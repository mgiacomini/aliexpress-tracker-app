class OrdersController < ApplicationController

  def track
    TrackOrderWorker.perform_async(params[:aliexpress].to_json, params[:wordpress].to_json, params[:aliexpress_number], params[:wordpress_reference])
    respond_with nil
  end

end