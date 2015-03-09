require 'singleton'

module Magister
  class TransformerRegistry
    include Singleton

    def initialize
      @register = {}
    end

    def self.transformer_context_index_keys
      transformer_index_keys = Magister::Config.index.keys
      transformer_index_keys.select do |key|
        key.match(/\/_\/transformers$/)
      end
    end

    def self.transformer_index_keys_in_contexts context_array
      context_array.map { |x| Entity.find(x).contents }
        .flatten
    end

    def self.initialize_register
      transformers = self.transformer_context_index_keys.map do |transformers_context_index_key| 
        Entity.find(transformers_context_index_key).contents
      end

      transformers.each do |transformer_context|
      end
        # Get the 'transform' entity from the context
    end

    def [] index_key
      @register[index_key]
    end

  end
end
