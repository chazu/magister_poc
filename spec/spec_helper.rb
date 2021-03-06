ENV['MAGISTER_ENV'] = "test"
ENV['RACK_ENV'] = 'test'

require "./lib/magister.rb"
require "./app.rb"
require 'rack/test'
require 'rspec'
require 'pry'

OUTER_APP = Rack::Builder.parse_file('config.ru').first

module RSpecMixin
  include Rack::Test::Methods

  def app
    OUTER_APP
  end
end

include Magister::Helpers

def register_transformer class_name
  # TODO Clear out transformer registry, add specified transformer instance to registry
end

def runtime_eval expression
  @@runtime.eval(expression)
end

def create_test_entity options
  ent = Magister::Entity.new({:context => index_key_to_context_array(options[:context]),
                              :name => options[:name],
                              :is_context => options[:is_context]} || false,
                             options[:data])
  ent.persist_recursively
end

# Take an array of length 2 and return a Heist Cons for it.
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


RSpec.configure do |c|
  c.include RSpecMixin
  before :all do
    if File.file?(Magister::Config.options["indexFileKey"])
      File.delete(Magister::Config.options["indexFileKey"])
    end
    Magister::Config.store.store.clear!
  end
end
