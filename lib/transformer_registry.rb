require 'singleton'

module Magister
  class TransformerRegistry
    include Singleton

    def initialize
      @register = {}
    end

    def [] index_key
      @register[index_key]
    end

  end
end
