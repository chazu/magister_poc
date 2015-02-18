module Magister
  class Entity

    attr_accessor :name, :context

    def self.request_index_key(request)
      (request.context ? "/" : "") +
        request.context.join("/") +
        (request.name && request.context.any? ? "/" : "") +
        (request.name ? request.name : "")
    end

    def self.context_from_index_key(index_key)
      split_path = index_key.split("/")
      has_name = index_key[-1] != "/"

      split_path.shift
      if (has_name)
        split_path.pop
      end
      split_path
    end

    def self.name_from_index_key(index_key)
      if index_key == "/"
        ""
      else
        index_key.split("/")[-1]
      end
    end

    def self.find(index_key)
      if index_key == "/"
        Entity.new({ context: [],
            name: nil,
            is_context: true
          }, nil)
      else
        if Magister::Config.index.keys.include? index_key
          index_entry = Magister::Config.index[index_key]
          is_context = index_entry[:_isContext]
          # Note we're lazily fetching the content from the store by
          # passing in nil here. Is this a good idea? Not so sure...
          Entity.new({context: Entity.context_from_index_key(index_key),
              name: Entity.name_from_index_key(index_key),
              is_context: is_context}, nil)
        end
      end
    end

    def initialize(options, data)
      # TODO should Entity take an index key for initialization?
      # TODO data should be optional so we dont have to pass nil in
      @context = options[:context]
      @name = options[:name]
      @is_context = options[:is_context]
      @data = data ? data : nil
    end

    def index_key
      (@context ? "/" : "") +
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

    def data
      if index_key == "/"
        @data # For a context, this is nothin...So how do we get the contents of a context?
      else
        if is_context?
          nil # TODO We'll create a #contents method for contexts
        else
          s3_key = index_key
          s3_key[0] = ""
          @data ||= Magister::Config.store.get(s3_key)
          # @data ||= Magister::Config.store.store.objects.find(index_key).content
        end
      end
    end

    def contents
      # TODO Spec this out before you write it, silly.
    end

    def persist
      # Add a terminating slash if its a context - for Amazon S3
      s3_key = is_context? ? index_key + "/" : index_key
      if s3_key[0] == "/"
        s3_key[0] = '' # Remove initial slash, cos s3
      end

      Magister::Config.index[index_key] = {
          metadata: {},
        _isContext: @is_context
      }
      store_object = Magister::Config.store.put(s3_key,
          @data)
    end
  end
end
