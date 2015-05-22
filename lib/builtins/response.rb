module Magister
  module TransformerBuiltins
    module Response
      #
      # TODO
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
