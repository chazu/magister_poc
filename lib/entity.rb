module Magister
  module Entity
    class Entity

      attr_accessor :name, :context

      def initialize(magister_request)
        @context = magister_request.context
        @name = magister_request.name
        @is_context = magister_request.is_context
      end

      def index_key
        (@context ? "/" : "") +
          @context.join("/") + 
          (@name && @context.any? ? "/" : "") + 
          (@name ? @name : "")
      end

      def exists?
        Magister::Config.index.keys.include?(index_key)
      end

      def is_context?
        @is_context
      end
    end
  end
end
