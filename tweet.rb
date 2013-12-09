require 'twitter'
require 'pry-debugger'
require 'pry-stack_explorer'
require_relative 'recent'

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

  def list_members_data(list)
    client.list_members(list).attrs[:users]
  end

  def list_members_ids(list)
    list_members_data('Information').map{|i| i[:id_str]}
  end

  def id(tweet)
    tweet.user.id
  end

  def message_with_username
    list_members_data('Information').collect{|tweet| Message.new(tweet.full_text, username(tweet), id(tweet))}
  end

  def stream_messages
    stream.site(:follow => list_members_ids('Information').first) do |object|
      puts "#{object.class}"
    end
  end

end
