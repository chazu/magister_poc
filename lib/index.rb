require 'forwardable'
require 'aws-sdk'
require 'daybreak'

include Forwardable

module Magister
  class Index
    extend Forwardable

    attr_accessor :index

    def_delegator :@index, :[], :[]
    def_delegator :@index, :[]=, :[]=
    def_delegator :@index, :keys, :keys
    def_delegator :@index, :lock, :lock
    def_delegator :@index, :flush, :flush

    def initialize(store)
      begin
        puts "Checking for index in remote store..."

        index_file = File.open("_index", "w")
        remote_index_data = Magister::Config.store.retrieve_index_data
        if remote_index_data
          index_file.write(remote_index_data.readlines.join) # TODO Can we ditch the #gets?
          index_file.close
        end
      rescue Aws::S3::Errors::NotFound => e
        puts "Index not found in remote store. Will initialize a new index."
      end
      @index = open_index_file_for_reading
    end

    def open_index_file_for_reading
      puts "Initializing Index..."
      Daybreak::DB.new "_index"
    end
  end
end
