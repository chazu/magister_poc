module Magister
  module Entity

    # TODO Just make Request and Entity classes with class methods,
    # instead of modules with classes in them
    
    def self.request_index_key(request)
      (request.context ? "/" : "") +
        request.context.join("/") +
        (request.name && request.context.any? ? "/" : "") +
        (request.name ? request.name : "")
    end

    class Entity

      attr_accessor :name, :context

      def self.find(index_key)
        # TODO Should return an Entity instance
        if Magister::Config.index.keys.include? index_key
          # TODO Entity should take an index key for initialization
      end

      def initialize(magister_request, content)
        # TODO content should be optional so we dont have to pass nil in
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

      def content
        @content ||= Magister::Config.store.objects[index_key].content
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
