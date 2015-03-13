require 'singleton'

module Magister
  class TransformerRegistry

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
      puts "initializing register"
      @@register = {}
      transformers = self.transformer_context_index_keys.map do |transformers_context_index_key| 
        Entity.find(transformers_context_index_key)
      end

      transformers.each do |transformer_entity|
        puts "Initializing transformer: " + transformer_entity.index_key
        if @@register.keys.include?(transformer_entity.index_key)
          @@register[transformer_entity.index_key] << transformer_entity
        else
          @@register[transformer_entity.index_key] = [Transformer.new(transformer_entity)]
        end
      end
    end

    def self.[] index_key
      @@register[index_key]
    end
  end
end
