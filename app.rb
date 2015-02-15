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

Magister::Config.set_store store
Magister::Config.set_index index

puts "==="

module Magister
  class MagisterApp < Sinatra::Application

    get '*' do
      req = Request::Request.new(request)
      # TODO Entity.new doesnt make sense here
      index_key = Entity.request_index_key(req)
      ent = Entity::Entity.find(index_key)
      if ent
        status 200
        body ent.content
      else
        status 404
      end
    end

    post '*' do
      req = Request::Request.new(request)
      puts request.body.gets # POST Params, request.params is url params
      # TODO Handle multipart uploads here
      #      Sometimes well want to save form data,
      #      sometimes the request body

      new_entity = Entity::Entity.new(req, request.body)
      if new_entity.exists? # exists? means is already saved
        status 405 # Can't post it, its already there bro
      else

        if new_entity.persist
          status 200
        else
          status 500
        end
      end

      # TODO Persist _index on s3
    end
  end
end
