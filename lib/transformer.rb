require 'json'
require 'heist'

module Magister
  class Transformer

    attr_accessor :runtime #This is hacky. In here so's testing is easy but its horrible.

    def initialize(transformer_entity)
      @runtime = Heist::Runtime.new
      # Load actual transformer code into runtime
      @entity = transformer_entity
      @domain = Entity.context_array_to_index_key(transformer_entity.context)
      @source = Entity.find(transformer_entity.index_key + "/transform").data.readlines.join
      @meta = Entity.find(transformer_entity.index_key + "/meta").data.readlines.join

      # Configure special forms
      @runtime.define 'meta' do |transforms, returns, deps|
        @transformers, @returns, @deps = transforms, returns, deps
      end

      # Scheme special form which converts a data structure to JSON.
      @runtime.define 'json-encode' do |expression|
        expression.to_json
      end

      @runtime.define 'find-entity' do |expression|
        binding.pry
        Entity.find(expression["context"] + expression["name"]).as_hash
      end

      evaluate_meta
    end

    def name
      @entity.name
    end

    def context
      @entity.context
    end

    def inject_request request
      @runtime.exec [:define, :request, [:quote, to_sexp(request.as_hash)]]
    end

    def inject_dependencies
      # TODO Grab contexts, other transformers, whatever,
      # and give our transformer handles to it
    end

    def as_hash
      # TODO Need accepts and returns here
      {
        "name" => name,
        "transforms" => @transforms,
        "returns" => @returns,
        "deps" => @deps,
        "domain" => @domain
      }
    end

    def evaluate_meta
      @runtime.send(:eval, @meta)

    end

    def evaluate
      binding.pry
      @runtime.send(:eval, @source)
    end
  end
end
