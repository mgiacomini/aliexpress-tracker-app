module Aliexpress
  class BrowserBuilder

    def self.build
      browser = Watir::Browser.new :phantomjs
      Watir.default_timeout = 90
      browser.window.maximize
      browser
    end

  end
end