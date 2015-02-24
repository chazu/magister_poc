require './lib/helpers'
require './lib/request'
require './lib/entity'
require './lib/store'
require './lib/index'
require './lib/adapters/base'
require './lib/adapters/s3_adapter'
require './lib/transformer'
require './lib/transformer_registry'

module Magister
  MAGISTER_BUCKET_NAME = "plaidpotion-magister-sinatra"

  def self.sync_index_to_store
    Config.index.flush
    Config.index.lock do
      print "Synchronizing index with remote store..."
      Config.index.flush
      index_file = File.open("_index", "r")

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
