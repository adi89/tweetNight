require 'pry-debugger'
require 'pry-stack_explorer'
require_relative 'stream'

def selection(choice)
  puts "You selected #{choice}.......".color("E89C0C")
end

def night_stream
  t = Stream.new(TweetResponse.new)

  puts "Select a category:"
  puts "(1) Information"
  puts "(2) High End DJs"
  puts "(3) NY Promoters"
  puts "(4) NY Scenesters"
  response = gets.chomp
  case response
  when '1'
    selection('Information')
    t.stream_messages('information')
  when '2'
    selection('High End DJs')
    t.stream_messages('high-end-djs')
  when '3'
    selection('NY Promoters')
    t.stream_messages('nyc-promoters')
  when '4'
    selection('NY Scenesters')
    t.stream_messages('nyc-scenesters')
  end
end

night_stream()