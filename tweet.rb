require 'twitter'
require 'pry-debugger'
require 'pry-stack_explorer'
require 'rainbow'

class Tweet
  attr_accessor :client
  def initialize
    @client = client
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def list_members_response(list, options)
    client.list_members(list, options)
  end

  def list_members_ids(list)
    collect_list_all_members_data(list).map{|i| i[:id_str]}
  end

  def arrayed_list_from_data(response)
    response.attrs[:users]
  end

  def list_members_string(list)
    list_members_ids(list).join(',')
  end

  def collect_list_all_members_data(list)
    collection = []
    cursor = -1
    while (cursor != 0)
      response = list_members_response(list, {:cursor => cursor})
      collection += arrayed_list_from_data(response)
      cursor = response.next_cursor
    end
    collection
  end

end