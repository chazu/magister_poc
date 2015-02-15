module Magister
  module Entity
    class Entity

      attr_accessor :name, :context

      def initialize(magister_request, content)
        @context = magister_request.context
        @name = magister_request.name
        @is_context = magister_request.is_context
        @content = content
      end

      def index_key
        @index_key ||= (@context ? "/" : "") +
          @context.join("/") + 
          (@name && @context.any? ? "/" : "") + 
          (@name ? @name : "")
      end

      def exists?
        (index_key == "/") ? true : Magister::Config.index.keys.include?(index_key)
      end

      def is_context?
        @is_context
      end

      def metadata
        # TODO Spec out this method
        Magister::Config.index[index_key]["metadata"]
      end

      def persist
        # Add a terminating slash if its a context - for Amazon S3
        s3_key = is_context? ? index_key + "/" : index_key

        if s3_key[0] == "/"
          s3_key[0] = '' # Remove initial slash, cos s3
        end

        Magister::Config.index[index_key] = {
          metadata: {}
        }
        store_object = Magister::Config.store.objects.build(s3_key)
        if @content
          store_object.content = @content
        end

        store_object.save
      end

    end
  end
end
