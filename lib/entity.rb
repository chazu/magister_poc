module Magister
  class Entity

    attr_accessor :name, :context

    def self.request_index_key(request)
      (request.context ? "/" : "") +
        request.context.join("/") +
        (request.name && request.context.any? ? "/" : "") +
        (request.name ? request.name : "")
    end

    def self.find(index_key)
      # TODO Should return an Entity instance
      if index_key == "/"
        Entity.new({ context: [],
            name: nil,
            is_context: true
          }, nil)
      else
        if Magister::Config.index.keys.include? index_key
          true # TODO Entity should take an index key for initialization
        end
      end
    end

    def initialize(options, content)
      # TODO content should be optional so we dont have to pass nil in
      @context = options[:context]
      @name = options[:name]
      @is_context = options[:is_context]
      @content = content ? content : nil
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
      # TODO Handle root context case
      # TODO rename this to data - content implies containment
      if index_key == "/"
        return "TODO"
      else
        @content ||= Magister::Config.store.objects.find(index_key).content
      end
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
      store_object = Magister::Config.store.put_object({key: s3_key,
          body: @content
        })
    end
  end
end
