require "./app.rb"
require "./lib/magister.rb"
require 'rack/test'
require 'rspec'
require 'pry'

ENV['RACK_ENV'] = 'test'

include Rack::Test::Methods

def app
  Magister::App
end
