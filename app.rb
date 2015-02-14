require './lib/magister.rb'

require 'sinatra'
require 'pry'

require 's3'
require 'daybreak'

puts "Connecting to service..."
service = S3::Service.new(access_key_id: 'AKIAIRG5ZJMOR42FQF5Q',
                      secret_access_key: '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')

puts "Selecting relevant service bucket..."
store = service.buckets.find("plaidpotion-magister-sinatra")

def initialize_index
  puts "Initializing Index..."
  Daybreak::DB.new "_index"
end

def find_or_create_index_for(store)
  puts "Checking for index in remote store..."
  obj = store.objects

  obj.map(&:to_s).include?("_index") ? store.objects.find("_index").content : initialize_index
end

index = find_or_create_index_for store

puts "==="

module Magister

  class MagisterApp < Sinatra::Application



    get '*' do
      context = Request::Request.new(request)

      context.path.to_s
    end

    post '*' do
      context = Request::Request.new(request)

      index
    end
  end
end
