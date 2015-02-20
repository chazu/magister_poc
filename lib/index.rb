require 'forwardable'

require 'aws-sdk'
require 'daybreak'

include Forwardable

module Magister
  class Index
    extend Forwardable

    def_delegator :@index, :[], :[]
    def_delegator :@index, :[]=, :[]=
    def_delegator :@index, :keys, :keys

    def initialize(store)
      begin
        # Magister::Config.store.head_object(bucket: Magister::MAGISTER_BUCKET_NAME,
        #   key: "_index")
        puts "Checking for index in remote store..."

        index_file = File.open("_index", "w")
        remote_index_data = Magister::Config.store.retrieve_index_data
        index_file.write(remote_index_data.gets) # TODO Can we ditch the #gets?
        index_file.close
      rescue Aws::S3::Errors::NotFound => e
        puts "Index not found in remote store. Initializing..."
      end
      @index = open_index_file_for_reading
    end

    def open_index_file_for_reading
      puts "Initializing Index..."
      Daybreak::DB.new "_index"
    end

    def [] key
    end
  end
end
