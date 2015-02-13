module Magister
  module Context
    class Context
      attr_accessor :path

      def initialize(request)
        split_path = request.path.split("/")
        has_name = request.path[-1] != "/"

        split_path.shift
        if (has_name)
          split_path.pop
        end
        @path = split_path.unshift :root_context
      end
    end
  end
end
