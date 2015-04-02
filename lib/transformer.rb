require 'heist'

module Magister
  class Transformer

    attr_accessor :runtime #This is hacky. In here so's testing is easy but its horrible.

    def initialize(transformer_entity)
      @runtime = Heist::Runtime.new
      # Load actual transformer code into runtime
      @entity = transformer_entity
      @source = Entity.find(transformer_entity.index_key + "/transform").data.readlines.join
      @meta = Entity.find(transformer_entity.index_key + "/meta").data.readlines.join

      # Configure special forms
      @runtime.define 'meta' do |transforms, returns, deps|
      end
      # TODO Define to-json special form

      evaluate_meta
    end

    def name
      @entity.name
    end

    def context
      @entity.context
    end

    def inject_request request
      @runtime.exec [:define, :request, request]
    end

    def inject_dependencies
      # TODO Grab contexts, other transformers, whatever,
      # and give our transformer handles to it
    end

    def to_hash
      # TODO Need accepts and returns here
      {
        "name" => name
      }
    end

    def evaluate_meta
      @runtime.send(:eval, @meta)
      # TODO Pull metadata out and save it as ivars
    end

    def evaluate
      binding.pry
      @runtime.send(:eval, @source)
    end
  end
end
