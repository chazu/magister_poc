module Magister
  class Request
    attr_accessor :context, :name, :is_context, :headers

    def http_request_indicates_context(request)
      if request.path == "/"
        return true
      else
        return request.path[-1] == "/" || request.env.has_key?("HTTP_MAGISTER_IS_CONTEXT")
      end
    end

    def initialize(http_request)

      @history = []

      # Its a context if the request has a terminating slash -
      # Headers can be used as well, but keep it simple for now
      @is_context = http_request_indicates_context(http_request)

      split_path = http_request.path.split("/")
      has_name = http_request.path[-1] != "/"

      split_path.shift
      if (has_name)
        @name = split_path.pop
      else
        @name = nil
      end

      @context = split_path
      @headers = http_request.env.select do |key, value|
        !/^rack/.match(key) && !/^sinatra/.match(key) && !/^async/.match(key)
      end # TODO Not really just headers, th entire rack env...
      @params
    end

    def history
      @history
    end

    def as_hash
      {
        "name" => name,
        "context" => Entity.context_array_to_index_key(context),
        "is_context" => is_context,
        "headers" => @headers
      }
    end
  end
end
