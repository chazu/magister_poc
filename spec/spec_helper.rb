require "./lib/magister.rb"
ENV['MAGISTER_ENV'] = "test"
require "./app.rb"

if File.file?(Magister::Config.options["indexFileKey"])
  File.delete(Magister::Config.options["indexFileKey"])
end

Magister::Config.store.store.clear!

def create_test_entity options
  ent = Magister::Entity.new({:context => options[:context],
    :name => options[:name],
    :is_context => options[:is_context]},
    options[:data])
  ent.persist_recursively
end

require 'rack/test'
require 'rspec'
require 'pry'

ENV['RACK_ENV'] = 'test'

include Rack::Test::Methods

def app
  Magister::App
end
