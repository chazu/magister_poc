require './lib/request.rb'
require './lib/entity.rb'

module Magister
  MAGISTER_BUCKET_NAME = "plaidpotion-magister-sinatra"

  def self.sync_index_to_store
    Config.index.lock do
      print "Synchronizing index with remote store..."
      Config.index.flush
      index_file = File.open(Config.index.file, "r")

      entity_opts = {
        context: [],
        name: "_index",
        is_context: false
      }
      index_entity = Entity.new(entity_opts, index_file)
      index_entity.persist
      puts "done."
    end
    Config.index
  end

  def self.synx_index_from_store
    
  end

  class Index

  end

  class Store
    attr_accessor :store

    def initialize
      print "Connecting to remote store..."
      credentials = Aws::Credentials.new('AKIAIRG5ZJMOR42FQF5Q', 'JLp6XjIzw9dYCEosgB5zWYlX1mhTnfzLbaj7/CoC')

      $s3_client = Aws::S3::Client.new region: 'us-east-1', credentials: credentials
      @store = Aws::S3::Bucket.new MAGISTER_BUCKET_NAME, client: $s3_client
    end

    def retrieve_index_data
      remote_index_data = @store.object("_index").get.body
    end

    def get(key)
      @store.object(key).get.body
    end

    def put(key, data)
      @store.put_object({
          key: key,
          body: data
        })
    end
  end

  class Config

    @store = nil
    @index = nil

    def self.store= store
      @store = store
    end

    def self.index= index
      @index = index
    end

    def self.store
      @store
    end

    def self.index
      @index
    end

    def self.instance
      self
    end

    def self.set_store store
      self.instance.store = store
    end

    def self.set_index index
      self.instance.index = index
    end
  end
end
