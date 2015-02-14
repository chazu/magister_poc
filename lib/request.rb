module Magister
  module Request
    class Request
      attr_accessor :context, :name

      def http_request_indicates_context(request)
        request.path[-1] == "/" || request.env["HTTP_MAGISTER_IS_CONTEXT"]
      end

      def initialize(http_request)

        # Its a context if the request has a terminating slash -
        # Headers can be used as well, but keep it simple for now
        @is_context = http_request_indicates_context http_request

        split_path = http_request.path.split("/")
        has_name = http_request.path[-1] != "/"

        split_path.shift
        if (has_name)
          @name = split_path.pop
        else
          @name = nil
        end
        @context = split_path

      end

    end
  end
end
