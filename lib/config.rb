require 'json'

module Magister
  class Config
    # TODO Make this a singleton?
    @store = nil
    @index = nil

    def self.set_env file_path
      file = File.read(file_path)
      @options = JSON.parse(file)
    end

    def self.options
      @options
    end

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
end
