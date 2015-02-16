require './lib/magister.rb'

require 'rufus-scheduler'
require 'sinatra'
require 'pry'

require 'aws-sdk'
require 'daybreak'

MAGISTER_BUCKET_NAME = "plaidpotion-magister-sinatra"

puts "Connecting to service..."
credentials = Aws::Credentials.new('AKIAIRG5ZJMOR42FQF5Q', 'JLp6XjIzw9dYCEosgB5zWYlX1mhTnfzLbaj7/CoC')

$s3_client = Aws::S3::Client.new region: 'us-east-1', credentials: credentials
$store = Aws::S3::Bucket.new MAGISTER_BUCKET_NAME, client: $s3_client

# s3_client = s3.Client.new

puts "Selecting relevant service bucket..."

def initialize_index
  puts "Initializing Index..."
  Daybreak::DB.new "_index"
end

def find_or_create_index_for(store)
  # TODO Daybreak DB isn't loaded properly when retrieved
  # from AWS. Should be saved to disk as file, then loaded
  begin
    puts "Checking for index in remote store..."
    $s3_client.head_object(bucket: MAGISTER_BUCKET_NAME,
      key: "_index")
    index = store.object("_index").get.body
  rescue Aws::S3::Errors::NotFound => e
    index = initialize_index
  end
  index
end

index = find_or_create_index_for $store

Magister::Config.set_store $store
Magister::Config.set_index index

scheduler = Rufus::Scheduler.new


scheduler.every '10s' do
  index.lock do
    index_file = File.open(index.file, "r")

  entity_opts = {
    context: [],
    name: "_index",
    is_context: false
  }

  Magister::Entity::Entity.new(entity_opts, index_file).persist

  end
end


puts "==="

module Magister
  class MagisterApp < Sinatra::Application

    get '*' do
      req = Request::Request.new(request)
      index_key = Entity.request_index_key(req)
      ent = Entity::Entity.find(index_key)

      if ent
        status 200
        body ent.content || ""
      else
        status 404
      end
    end

    post '*' do
      req = Request::Request.new(request)
      # TODO Handle multipart uploads here
      #      Sometimes well want to save form data,
      #      sometimes the request body

      new_entity = Entity::Entity.new({
          context: req.context,
          name: req.name,
          is_context: req.is_context
        }, request.body.gets)
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
