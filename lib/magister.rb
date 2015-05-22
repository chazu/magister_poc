require './lib/helpers'
require './lib/request'
require './lib/entity'
require './lib/store'
require './lib/index'
require './lib/config'
require './lib/builtins'
require './lib/scheduler'
require './lib/adapters/base'
require './lib/adapters/s3_adapter'
require './lib/handlers/get'
require './lib/handlers/post'
require './lib/handlers/put'
require './lib/handlers/delete'
require './lib/handlers/patch'

require './lib/transformer'
require './lib/default_transformers'
require './lib/transformer_registry'
require './lib/transformer_executor'

# require './lib/shutdown'
module Magister
  def self.sync_index_to_store
    Config.index.flush

    Config.index.lock do
      Config.index.flush
      index_file = File.open("_index", "r")

      entity_opts = {
        context: [],
        name: "_index",
        is_context: false
      }
      index_entity = Entity.new(entity_opts, index_file)
      index_entity.persist
    end
    Config.index
  end
end
