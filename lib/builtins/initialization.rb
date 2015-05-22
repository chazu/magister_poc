module Magister
  module TransformerBuiltins
    module Initialization

      def included base
        module_eval do
        def define_init_builtins
          @runtime.define 'transformer-name' do
            name
          end
          
          @runtime.define 'meta' do |transforms, returns, verbs, deps|
            @transforms, @returns, @verbs, @deps = from_sexp(transforms.cdr), from_sexp(returns.cdr), from_sexp(verbs.cdr), from_sexp(deps.cdr)
          end

          @runtime.define 'config' do |expression|
            @config = from_sexp(expression)
          end

          @runtime.define 'entity-data' do |entity|
            entity.data
          end
        end
        end
      end
    end
  end
end
