require 'json'
require 'heist'

module Magister
  class Transformer

    attr_accessor :runtime #This is hacky. In here so's testing is easy but its horrible.
    attr_accessor :returns, :transforms, :deps, :verbs
    def initialize(transformer_entity)
      @runtime = Heist::Runtime.new
      # Load actual transformer code into runtime
      @entity = transformer_entity
      @domain = domain_from_installed_context transformer_entity
      @source = Entity.find(transformer_entity.index_key + "/transform").data.readlines.join
      @meta = Entity.find(transformer_entity.index_key + "/meta").data.readlines.join

      # Configure special forms
      @runtime.define 'meta' do |transforms, returns, verbs, deps|
        @transforms, @returns, @verbs, @deps = from_sexp(transforms.cdr), from_sexp(returns.cdr), from_sexp(verbs.cdr), from_sexp(deps.cdr)
      end

      # Scheme special form which converts a data structure to JSON.
      @runtime.define 'json-encode' do |expression|
        from_sexp(expression).to_json
      end

      @runtime.define 'find-entity' do |index_key|
        # TODO Fix this - need to convert to hash and then to sexp
        Entity.find(index_key)
      end

      evaluate_meta
    end

    def name
      @entity.name
    end

    def context
      Entity.context_array_to_index_key(@entity.context)
    end

    # Return the actual domain of the transformer by removing the
    # _/transformers bit of the index key
    # Takes an entity
    def domain_from_installed_context transformer_entity
      index_key = Entity.context_array_to_index_key(transformer_entity.context)
      actual_domain = index_key.gsub("/_/transformers", "")
      if actual_domain == ""
        actual_domain = "/"
      end
      actual_domain
    end

    # Set the entity which is the target of the current request under transformation
    def set_entity ent
      @requested_entity = ent
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
      @runtime.send(:eval, @source)
    end
  end
end
