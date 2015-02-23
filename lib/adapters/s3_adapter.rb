require './lib/adapters/base'

module Magister
  module StorageAdapters
    class S3Adapter < Base

      attr_accessor :store

      def initialize
        credentials = Aws::Credentials.new('AKIAIRG5ZJMOR42FQF5Q', 'JLp6XjIzw9dYCEosgB5zWYlX1mhTnfzLbaj7/CoC')

        $s3_client = Aws::S3::Client.new region: 'us-east-1', credentials: credentials
        @store = Aws::S3::Bucket.new MAGISTER_BUCKET_NAME, client: $s3_client
      end

      def retrieve_index_data
        begin
          remote_index_data = @store.object("_index").get.body
        rescue Aws::S3::Errors::NoSuchKey => e
          nil
        end
        remote_index_data
      end

      def get(index_key)
      @store.object(index_key).get.body
      end

      def put(index_key, data)
      @store.put_object({
          key: index_key,
          body: data
        })
      end

    end
  end
end
