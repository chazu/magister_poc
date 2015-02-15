require './lib/request.rb'
require './lib/entity.rb'

module Magister
  class Config

    @store = nil
    @index = nil

    def self.store= store
        @store = store
    end

    def self.index= index
      @index = index
    end

    def self.store
      @store
    end

    def self.index
      @index
    end

    def self.instance
      self
    end

    def self.set_store store
      self.instance.store = store
    end

    def self.set_index index
      self.instance.index = index
    end
  end

  include Magister::Request
  include Magister::Entity
end
