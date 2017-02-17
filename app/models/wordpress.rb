require 'woocommerce_api'

class Wordpress
  include ActiveModel::Model
  attr_accessor :url, :consumer_key, :consumer_secret
  validates_presence_of :url, :consumer_key, :consumer_secret
end