require './lib/magister.rb'

require 'rufus-scheduler'
require 'sinatra'
require 'pry'

require 'aws-sdk'
require 'daybreak'

MAGISTER_BUCKET_NAME = "plaidpotion-magister-sinatra"

print "Connecting to remote store..."
credentials = Aws::Credentials.new('AKIAIRG5ZJMOR42FQF5Q', 'JLp6XjIzw9dYCEosgB5zWYlX1mhTnfzLbaj7/CoC')

$s3_client = Aws::S3::Client.new region: 'us-east-1', credentials: credentials
$store = Aws::S3::Bucket.new MAGISTER_BUCKET_NAME, client: $s3_client

Magister::Config.set_store $store
puts "done."

def initialize_index
  puts "Initializing Index..."
  Daybreak::DB.new "_index"
end

def find_or_create_index_for(store)
  begin
    puts "Checking for index in remote store..."
    $s3_client.head_object(bucket: MAGISTER_BUCKET_NAME,
      key: "_index")
    index_file = File.open("_index", "w")
    remote_index_data = store.object("_index").get.body
    index_file.write(remote_index_data.gets)
    index_file.close
    Magister::Config.set_index Daybreak::DB.new "_index"
  rescue Aws::S3::Errors::NotFound => e
    puts "Index not found in remote store. Initializing..."
    Magister::Config.index = initialize_index
  end
end

index = find_or_create_index_for $store

scheduler = Rufus::Scheduler.new

# scheduler.every '10s' do
#   Magister.sync_index_to_store
# end

puts "==="

module Magister
  class App < Sinatra::Application

    get '*' do
      req = Request.new(request)
      index_key = Entity.request_index_key(req)
      ent = Entity.find(index_key)

      if ent
        status 200
        body ent.data || ""
      else
        status 404
      end
    end

    post '*' do
      req = Request.new(request)

      if !req.is_context
        if request.params["_magister_file"]
          data = request.params["_magister_file"][:tempfile].read
        else
          data = request.body.gets

        end
      else
        data = nil
      end
      new_entity = Entity.new({
          context: req.context,
          name: req.name,
          is_context: req.is_context
        }, data)
      if new_entity.exists? # exists? means is already saved
        status 405 # Can't post it, its already there bro
      else
        if new_entity.persist
          status 200
        else
          status 500
        end
      end
    end
  end
end
