require 'heist'

module Magister
  class Transformer

    attr_accessor :runtime #This is hacky. In here so's testing is easy but its horrible.

    def initialize(transform_entity)
      @runtime = Heist::Runtime.new
      # Load actual transformer code into runtime
      @source = transform_entity.data

      evaluate

      # Get dependency info from transformer
      # @deps = @runtime.eval("(deps)")
    end

    def inject_request request
      @runtime.exec [:define, :request, request]
    end

    def inject_dependencies
      # TODO Grab contexts, other transformers, whatever,
      # and give our transformer handles to it
    end

    def evaluate
      @runtime.eval(@source)
    end
  end
end
