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

def make_cons_pair pair
  Heist::Runtime::Cons.new pair[0], pair[1]
end

@@runtime = Heist::Runtime.new
@@runtime.define 'assert-equal' do |expected, actual|
  actual.should == expected
end

@@runtime.define 'assert-equal-stringwise' do |expected, actual|
  actual.to_s.should == expected.to_s
end

def inject_data data, name
  @@runtime.send(:exec, [:define, name.to_sym, [ :quote, data ] ])
end

require 'rack/test'
require 'rspec'
require 'pry'

ENV['RACK_ENV'] = 'test'

include Rack::Test::Methods

def app
  Magister::App
end
