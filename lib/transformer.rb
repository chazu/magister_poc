require 'json'
require 'heist'

module Magister
  class Transformer
    include Magister::TransformerBuiltins

    attr_accessor :runtime #This is hacky. In here so's testing is easy but its horrible.
    attr_accessor :returns, :transforms, :deps, :verbs, :domain

    def initialize(transformer_entity)
      @runtime = Heist::Runtime.new

      # Load actual transformer code into runtime
      @entity = transformer_entity
      @domain = domain_from_installed_context transformer_entity
      @source = Entity.find(transformer_entity.index_key + "/transform").data
      @meta = Entity.find(transformer_entity.index_key + "/meta").data
      @config = Entity.find(transformer_entity.index_key + "/config").data

      @transforms = {}
      @returns = {}

      # Response ivars
      @status = nil
      @headers = []
      @body = nil
      
      # Configure special forms
      define_builtins

      #
      # TODO Should these be procs or just injected data?
      # Return the index key of the directory holding this transformer
      @runtime.define 'transformer-context' do
        @entity.index_key
      end

      # Return the index key of the context into which we've installed this transformer
      @runtime.define 'transformer-domain' do
        @domain
      end
      @runtime.define 'split-path' do |path_string|
        to_sexp(path_string.split("/"))
      end

      @runtime.define 'join-path' do |path_list|
        to_sexp(from_sexp(path_list).join("/"))
      end
      
      @runtime.define 'debug' do
        binding.pry
      end

      @runtime.define 'transformer-name' do
        name
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

    def evaluate_config
      @runtime.send(:eval, @config)
    end
    
    def evaluate
      @runtime.send(:eval, @source)
    end

    private
    def re source # Short for runtime evaluate
      @runtime.send(:eval, source)
    end
  end
end
