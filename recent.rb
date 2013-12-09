require 'pry-debugger'
require 'pry-stack_explorer'


class Recent
  def self.yesterday_unix
    Time.now.to_i - (24 * 60 * 60)
  end

  def self.yesterday
    Time.at(yesterday_unix)
  end

  def self.last_24_hours(tweet_message)
    tweet_message.created_at >= Recent.yesterday
  end

end