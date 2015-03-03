require "./lib/helpers"
include Magister::Helpers

module Magister
  class Entity
    include Helpers

    attr_accessor :name, :context

    def self.index_key_to_context_array(index_key)
      # TODO Make it so that only index keys are passed around, none of this
      # Context Array bullshit
      split = index_key.split("/")
      split.shift
      split
    end

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
        if entity_exists(index_key)
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

    def initialize(options, data=nil)
      # TODO should Entity take an index key for initialization?
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

    def enclosing_context_index_key
      # TODO Spec this
      "/" + @context.join("/")
    end

    def exists?
      (index_key == "/") ? true : Magister::Config.index.keys.include?(index_key)
    end

    def deleted?
      Magister::Config.index[index_key][:_deleted] || false;
    end

    def is_context?
      @is_context
    end

    def metadata
      Magister::Config.index[index_key][:metadata]
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
      #^(\/[a-zA-Z\/\_\-]+)
      index_regexp = Regexp.new(/^(?<key>\/[a-zA-Z\/\_\-]+)\//)
      res = Magister::Config.index.keys.select do |this_key|
        results = index_regexp.match(this_key)
        results && results["key"] == index_key
      end
      res.map do |x|
        {"name" => x}
      end
    end

    def persist
      # Add a terminating slash if its a context - for Amazon S3
      print "Persisting index key " + index_key + " indexing..."
      s3_key = is_context? ? index_key + "/" : index_key
      if s3_key[0] == "/"
        s3_key[0] = '' # Remove initial slash, cos s3
      end

      Magister::Config.index[index_key] = {
          metadata: {},
        _isContext: @is_context
      }
      print "adding to store...\n"
      store_object = Magister::Config.store.put(s3_key,
          @data)
    end

    def persist_recursively
      puts "Recursively persisting index key: " + index_key
      # Find all the contexts between us and root
      contexts_to_ensure = expand_index_key(enclosing_context_index_key)
      contexts_to_create = contexts_to_ensure.reject do |key_for_context|
        context_exists key_for_context
      end

      # Create any enclosing contexts which do not exist
      contexts_to_create.each do |context|
        if context != "/" # Root exists already, yo

          split_context = context.split("/")
          split_context.shift #Remove empty quote from root slash
          name = split_context.pop # Beware, I'm mutating split_context here!

          enclosing_context = "/" + split_context.join("/")
          the_new_context = Entity.new({context: Entity.index_key_to_context_array(enclosing_context),
              name: name,
              is_context: true})
          the_new_context.persist
        end
      end

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
