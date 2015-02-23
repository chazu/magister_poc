module Magister
  module StorageAdapters
    class Base

      def initialize
        raise Exception, "Constructor must be implemented by subclass of StorageAdapters::Base"
      end

      def retrieve_index_data
        raise Exception, "This method must be implemented by subclass of StorageAdapters::Base"
      end

      def get(index_key)
        raise Exception, "This method must be implemented by subclass of StorageAdapters::Base"
      end

      def put(index_key, data)
        raise Exception, "This method must be implemented by subclass of StorageAdapters::Base"
      end
    end
  end
end
