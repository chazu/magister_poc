module Magister
  module TransformerBuiltins
    module Paths

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
    end
  end
end
