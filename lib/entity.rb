module Magister
  module Entity
    class Entity

      def initialize(magister_request)
        @context = magister_request.context
        @name = magister_request.name
      end

      def index_key
        (@context ? "/" : "") +
          @context.join("/") + 
          (@name && @context.any? ? "/" : "") + 
          (@name ? @name : "")
      end

      def exists?
        true
      end

      def is_context?
        true
      end
    end
  end
end
