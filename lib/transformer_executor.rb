require 'singleton'

module Magister
  class TransformerExecutor

    def self.handle_request req
      # Handle request and return the response
      transformer = Magister::TransformerRegistry.transformer_for_request(req)

      puts "Executing Transformer: " + transformer.name

      req.history << transformer
      transformer.inject_request(req)

      index_key = Entity.request_index_key(req)
      ent = Entity.find(index_key)
      transformer.set_entity ent

      result = transformer.evaluate
      result
    end
  end
end
