require 'singleton'
require 'json'

require 'colorize'
module Magister
  class TransformerRegistry

    def self.transformer_for_request req
      @@registry["/_/transformers"][0]
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


      @@registry = {}

      transformer_contexts_index_keys = self.transformer_context_index_keys # Index keys for contexts containing transformers
      transformer_index_keys = self.index_keys_in_contexts(transformer_contexts_index_keys) # Should be all the transformers' index keys
      transformer_entities = transformer_index_keys.map { |x| Entity.find(x) }

      transformer_entities.each do |transformer_entity|
        begin
          puts "Initializing transformer: " + transformer_entity.index_key
          binding.pry    
          index_key_for_transformers_home_context = Entity.context_array_to_index_key(transformer_entity.context)
          if @@registry.keys.include?(index_key_for_transformers_home_context)

            @@registry[index_key_for_transformers_home_context] << Transformer.new(transformer_entity)
          else
            @@registry[index_key_for_transformers_home_context] = [Transformer.new(transformer_entity)]
          end
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
      mapped = @@registry.map do |key, value|
        sigh = {"context" => key,
          "transformers" => []}
        value.each do |transformer|
          sigh["transformers"] << transformer.as_hash
        end
        sigh
      end
      mapped.to_json
    end
  end
end
