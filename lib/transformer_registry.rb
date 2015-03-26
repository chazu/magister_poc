require 'singleton'

module Magister
  class TransformerRegistry

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
      begin

      @@registry = {}

      transformer_contexts_index_keys = self.transformer_context_index_keys # Index keys for contexts containing transformers
      transformer_index_keys = self.index_keys_in_contexts(transformer_contexts_index_keys) # Should be all the transformers' index keys
      transformer_entities = transformer_index_keys.map { |x| Entity.find(x) }

      transformer_entities.each do |transformer_entity|
        puts "Initializing transformer: " + transformer_entity.index_key
        if @@registry.keys.include?(transformer_entity.index_key)
          @@registry[transformer_entity.index_key] << transformer_entity
        else
          @@registry[transformer_entity.index_key] = [Transformer.new(transformer_entity)]
        end
      end

      rescue Exception => e
        puts "Exception while initializing Transformer Registry:"
        puts e
        puts "********** ************"
      end
    end

    def self.[] index_key
      @@registry[index_key]
    end

    def self.to_json
      # TODO Should the registry be a hash or an array? Hash seems...weird.
      mapped = @@registry.map do |key, value|
        {"name" => transformer.name,
        "context" => transformer.context}
      end

      mapped.to_json
    end
  end
end
