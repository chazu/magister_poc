require 'forwardable'

module Magister
  class Store
    extend Forwardable

    def_delegator :@adapter, :get, :get
    def_delegator :@adapter, :put, :put
    def_delegator :@adapter, :retrieve_index_data, :retrieve_index_data
    def_delegator :@adapter, :store, :store

    def initialize
      print "Connecting to remote store..."
      @adapter = Magister::StorageAdapters::S3Adapter.new
    end
  end
end
