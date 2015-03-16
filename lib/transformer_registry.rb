require 'singleton'

module Magister
  class TransformerRegistry

    def self.transformer_context_index_keys
      transformer_index_keys = Magister::Config.index.keys
      transformer_index_keys.select do |key|
        key.match(/\/_\/transformers$/)
      end
    end

    def self.transformer_index_keys_in_contexts entity_array
      entity_array.map { |x| x.contents }
        .flatten
        .map { |x| x["name"] }
    end

    def self.initialize_register
      puts "initializing register"
      @@register = {}
      transformer_contexts = self.transformer_context_index_keys.map do |transformers_context_index_key| 
        Entity.find(transformers_context_index_key)
      end
      transformer_index_keys = self.transformer_index_keys_in_contexts(transformer_contexts)
      transformer_entities = transformer_index_keys.map { |x| Entity.find(x) }
      transformer_entities.each do |transformer_entity|
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
