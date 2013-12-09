require_relative 'spec_helper'
require_relative '../tweet_response'

describe TweetResponse do
  let(:tweet) {TweetResponse.new}

  describe '#initialize' do
    it 'creates an instance of Tweet' do
      expect(tweet).to be_an_instance_of(TweetResponse)
    end
    it 'initializes with a client' do
      expect(tweet.client).to_not eq nil
    end
  end

  describe '#response methods' do
    before(:each) do
      @info_response = tweet.list_members_response('information', {})
      @collect_list_all_members_data = tweet.collect_list_all_members_data('information')
      @arrayed_list_from_data = tweet.arrayed_list_from_data(@info_response)
      tweet.stub(:collect_list_all_members_data).and_return @collect_list_all_members_data
    end
    it 'returns a list response from twitter' do
      expect(@info_response.class).to eq Twitter::Cursor
    end
    it 'parses the response into an array' do
      expect(@arrayed_list_from_data.class).to eq Array
    end
    it 'returns a FULL response' do
      expect(@collect_list_all_members_data.class).to eq Array
    end

    it 'collect_list_all_members_data should have more items than info_response' do
      @collect_list_all_members_data.count.should be > @arrayed_list_from_data.count
    end
    it 'list members ids' do
      expect(tweet.list_members_ids('information').first.class).to eq String
    end

    it 'list members string' do
      expect(tweet.list_members_string('information').class).to eq String
    end
  end
end
