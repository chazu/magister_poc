require 'singleton'

module Magister
  class TransformerRegistry
    include Singleton

    def initialize
      @register = {}
    end

    def self.initialize_register
      transformer_index_keys = Magister::Config.index.keys
      transformer_index_keys.select do |key|
        key
      end
    end

    def [] index_key
      @register[index_key]
    end

  end
end
