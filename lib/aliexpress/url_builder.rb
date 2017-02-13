module Aliexpress
  class UrlBuilder

    def self.logisticsdetail(aliexpress_number)
      "http://track.aliexpress.com/logisticsdetail.htm?tradeId=#{aliexpress_number}"
    end

    def self.authentication
      "https://login.aliexpress.com/"
    end

  end
end