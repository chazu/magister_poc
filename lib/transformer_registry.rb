require 'singleton'
require 'json'

require 'colorize'
module Magister
  class TransformerRegistry

    def self.transformer_for_request req
      # Find all possible transformers for the index path, all the way to the root
      context_index_key = context_array_to_index_key(req.context)
      contexts_above = expand_index_key(context_index_key)

      transformer_contexts_above = contexts_above.map do |x|
        if x == "/"
          x += "_/transformers"
        else
          x += "/_/transformers"
        end
      end
      
      eligible_transformers = @@registry.select do |transformer|

        transformer_contexts_above.include? transformer.context
      end
      binding.pry

      # Filter out the ones that don't transform the content-type specified in the request
      # i.e. the request's content-type doesn't match one of the types specified in the transformer's 'transforms' meta
      # Finally, filter out all those whose 'returns' meta doesn't match the HTTP_ACCEPT header of the request
      
      @@registry[0]
    end

    def self.transformer_context_index_keys
      # Get all the index keys in the store which match the regex for transformer storage
      transformer_index_keys = Magister::Config.index.keys
      transformer_index_keys.select do |key|
        key.match(/\/_\/transformers$/)
      end
    end

    def self.index_keys_in_contexts index_key_array
      # Given array of index keys for contexts containing transformers, get all the contents
      # as index keys. 
      index_key_array
        .map { |x| Entity.find(x) }
        .map { |x| x.contents }
        .flatten
    end

    def self.registry
      @@registry
    end

    def self.initialize_register
      puts "initializing register"


      @@registry = []

      transformer_contexts_index_keys = self.transformer_context_index_keys # Index keys for contexts containing transformers
      transformer_index_keys = self.index_keys_in_contexts(transformer_contexts_index_keys) # Should be all the transformers' index keys
      transformer_entities = transformer_index_keys.map { |x| Entity.find(x) }

      transformer_entities.each do |transformer_entity|
        begin
          puts "Initializing transformer: " + transformer_entity.index_key
          binding.pry
          index_key_for_transformers_home_context = Entity.context_array_to_index_key(transformer_entity.context)
          @@registry << Transformer.new(transformer_entity)
        rescue Exception => e
          puts "Exception while initializing Transformer Registry:"
          puts e
          puts "===".red + "WISE UP SUCKER!".blue + "===".red
        end
      end
    end

    def self.[] index_key
      @@registry[index_key]
    end

    def self.to_json
      mapped = @@registry.map do |transformer|
        transformer.as_hash
      end
      mapped.to_json
    end
  end
end
