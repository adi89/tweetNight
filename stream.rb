require 'pry-debugger'
require 'pry-stack_explorer'
require 'rainbow'
require_relative 'tweet_response'

class Stream
  attr_accessor :stream, :tweet_response
  def initialize(tweet)
    @tweet_response = tweet
    @stream = stream
  end

  def stream
    Twitter::Streaming::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_CONSUMER_KEY']
      config.consumer_secret     = ENV['TWITTER_CONSUMER_SECRET']
      config.access_token        = ENV['TWITTER_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_ACCESS_TOKEN_SECRET']
    end
  end

  def filter_stream(list)
    stream.filter(:follow => tweet_response.list_members_string(list)) do |object|
      parse_stream(object)
    end
  end

  def stream_messages(list)
    max = 3
    num = 0
    begin
      num += 1
      filter_stream(list)
  rescue Twitter::Error::TooManyRequests => error
    if num <= max
      sleep error.rate_limit.reset_in
      retry
    else
      raise
    end
  end
end

def parse_stream(object)
  if object.is_a?(Twitter::Tweet)
    print_tweet(object)
  end
end

def username(tweet)
  tweet.user.screen_name
end

def full_text(tweet)
  tweet.full_text
end

def print_tweet(tweet)
  puts "#{username(tweet)}: ".color("440CE8") + "#{full_text(tweet)}".foreground(:cyan)
end

end
