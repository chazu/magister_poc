module Magister
  module Request
    class Request
      attr_accessor :context, :name

      def initialize(http_request)
        split_path = http_request.path.split("/")
        has_name = http_request.path[-1] != "/"

        split_path.shift
        if (has_name)
          @name = split_path.pop
        else
          @name = nil
        end
        @context = split_path.unshift "root"
      end
    end
  end
end
