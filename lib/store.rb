module Magister
  class Store
    attr_accessor :store

    def initialize
      print "Connecting to remote store..."
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

    def get(key)
      @store.object(key).get.body
    end

    def put(key, data)
      @store.put_object({
          key: key,
          body: data
        })
    end
  end
end
