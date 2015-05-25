require 'singleton'
require 'json'

require 'colorize'
module Magister
  class TransformerRegistry

    def self.transformer_for_request req
      
      # Order from most specific to least specific
      # in terms of domain
      eligible_transformers = transformers_for_request(req).sort! do |a, b|
        a_length = a.domain.split("/").length
        b_length = b.domain.split("/").length
        case
        when a_length > b_length
          1
        when a_length == b_length
          0
        when a_length < b_length
          -1
        end
      end

      # Filter for request verbs
      handles_specified_verb = eligible_transformers.select do |transformer|
        transformer.verbs.include? req.headers["REQUEST_METHOD"]
      end

      # Filter on the 'returns' types for each transformer
      if req.headers["HTTP_ACCEPT"] && req.headers["HTTP_ACCEPT"] != "*/*"
        return_specified_type = handles_specified_verb.select do |transformer|
          transformer.returns.include? req.headers["HTTP_ACCEPT"]
        end
      else
        return_specified_type = eligible_transformers
      end

      # Filter out the ones that don't transform the content-type specified in the request
      if req.headers["CONTENT_TYPE"] && req.headers["CONTENT_TYPE"] != "*/*"
        transform_specified_type = return_specified_type.select do |transformer|
          transformer.transforms.include? req.headers["CONTENT_TYPE"]
        end
      else
        transform_specified_type = return_specified_type
      end
      return_specified_type.last
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

    def self.transformers_for_request req
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
      
      @@registry.select do |transformer|
        transformer_contexts_above.include? transformer.context
      end
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
