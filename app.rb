require './lib/magister.rb'

require 'rufus-scheduler'
require 'sinatra'
require 'pry'

if ENV['MAGISTER_ENV'] == "test"
  puts "Setting ENV to TEST"
  Magister::Config.set_env "./config/test.json"
else
  puts "Setting ENV to DEV"
  Magister::Config.set_env "./config/dev.json"
end

store = Magister::Store.new
Magister::Config.set_store store
Magister::Config.set_index Magister::Index.new store

# Initialize Transformer Registry
Magister::TransformerRegistry.initialize_register

scheduler = Rufus::Scheduler.new
scheduler.every '30s' do
  Magister.sync_index_to_store
end

module Magister
  class App < Sinatra::Application
    include Magister::API::GetHandler
    include Magister::API::PostHandler
    include Magister::API::PutHandler
    include Magister::API::DeleteHandler
  end
end
