require_relative 'spec_helper'
require_relative '../stream'

describe Stream do
  let(:stream) {Stream.new(Tweet.new)}
  describe 'tweet methods' do
    before(:each) do
      @message = stream.tweet.client.status(27558893223)
    end
    it '#full text' do
      expect(stream.full_text(@message)).to eq "Ruby is the best programming language for hiding the ugly bits."
    end
    it '#username' do
      expect(stream.username(@message)).to eq "sferik"
    end
    it '#print_tweet' do
      stream.stub(:print_tweet).and_return("Ruby is the best programming language for hiding the ugly bits.")
      expect(stream.print_tweet(@message)).to eq "Ruby is the best programming language for hiding the ugly bits."
    end
  end
end
