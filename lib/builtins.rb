module Magister
  module TransformerBuiltins
    def define_builtins
      @runtime.define 'meta' do |transforms, returns, verbs, deps|
        @transforms, @returns, @verbs, @deps = from_sexp(transforms.cdr), from_sexp(returns.cdr), from_sexp(verbs.cdr), from_sexp(deps.cdr)
      end

      @runtime.define 'string-sub' do |string, find, replace|
        string.gsub(from_sexp(find), from_sexp(replace))
      end

      @runtime.define 'config' do |expression|
        @config = from_sexp(expression)
      end
      # Scheme special form which converts a data structure to JSON.
      @runtime.define 'json-encode' do |expression|
        from_sexp(expression).to_json
      end

      @runtime.define 'find-entity' do |index_key|
        # TODO Fix this - need to convert to hash and then to sexp
        entity = Entity.find(index_key)
        to_sexp(entity ? entity : false)
      end

      @runtime.define 'entity-data' do |entity|
        entity.data
      end
      
      #
      #
      # Setting status, headers and body
      @runtime.define 'body' do |thing|
        @body = thing
      end

      @runtime.define 'header' do |header|
        @headers << from_sexp(header)
      end

      @runtime.define 'status' do |status|
        @status = from_sexp(status)
      end
    end
  end
end
