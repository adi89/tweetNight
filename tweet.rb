require 'twitter'
require 'pry-debugger'
require 'pry-stack_explorer'

class Tweet
  attr_accessor :client
  def initialize
    #   # @name = name
    @client = client
    @stream = stream
  end

  def client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def stream
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  Message = Struct.new(:full_text, :username, :id)

  def list_members_timeline_data(list)
    client.list_timeline(list, {count: 200})
  end

  def username(tweet)
    tweet.user.screen_name
  end

  def list_members_response(list, options)
    client.list_members(list, options)
  end

  def list_members_ids(list)
    collect_list_all_members_data(list).map{|i| i[:id_str]}
  end

  def list_members_string(list)
    list_members_ids(list).join(',')
  end

  def id(tweet)
    tweet.user.id
  end

  def message_with_username(list)
    collect_list_all_members_data(list).collect{|tweet| Message.new(tweet.full_text, username(tweet), id(tweet))}
  end

  def stream_messages(list)
    stream.filter(:follow => list_members_string(list)) do |object|
      puts "#{username(object)}: #{object.full_text}" if object.is_a?(Twitter::Tweet)
    end
  end

  def collect_list_all_members_data(list)
    collection = []
    cursor = -1
    while (cursor != 0)
      response = list_members_response(list, {:cursor => cursor})
      collection += response.attrs[:users]
      cursor = response.next_cursor
    end
    collection
  end

end
