require 'heist'

module Magister
  class Transformer

    def initialize
      @runtime = Heist::Runtime.new
      # Load actual transformer code into runtime
      @source = "(string \"hello!\")"

      # Get dependency info from transformer
      @deps = @runtime.eval("(deps)")
    end

    def inject_dependencies
      # TODO Grab contexts, other transformers, whatever,
      # and give our transformer handles to it
    end

    def execute
      @runtime.eval(@source)
    end
  end
end
