module Magister
  module TransformerBuiltins
    def define_builtins

      # HTTP Client methods
      @runtime.define 'http-get' do |alist|
        options = from_sexp(alist)
        binding.pry
      end

      # Yield
      @runtime.define 'yield' do |args|
        # TODO Call transformer, execute, return
      end

      @runtime.define 'yield-or-return' do
        # TODO Implicitly call another transformer
      end
      
      @runtime.define 'verbs' do |*verb_list|
        @verbs = from_sexp(verb_list)
      end

      @runtime.define 'deps' do |*deps_list|
        @deps = from_sexp(deps_list).flatten
      end
      
      @runtime.define 'transforms' do |type|
        major, minor = from_sexp(type).split("/")

        if !@transforms[major]
          @transforms[major] = []
        end

        if @transforms[major] && !@transforms[major].include?(minor)
          @transforms[major] << minor
        end
      end

      @runtime.define 'returns' do |type|
        major, minor = from_sexp(type).split("/")

        if !@returns[major]
          @returns[major] = []
        end

        if @returns[major] && !@returns[major].include?(minor)
          @returns[major] << minor
        end
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
