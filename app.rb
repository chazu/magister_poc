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

    get '*' do
      req = Request.new(request)
      index_key = Entity.request_index_key(req)
      ent = Entity.find(index_key)
      if ent
        status 200
        body ent.data || ""
      else
        status 404
      end
    end

    post '*' do
      req = Request.new(request)
      if !req.is_context
        if request.params["_magister_file"]
          if request.params["_magister_file"].class != String
            data = request.params["_magister_file"][:tempfile].read
          else
            data = request.params["_magister_file"]
          end
        else
          data = request.body.gets
        end
      else
        data = nil
      end

      new_entity = Entity.new({
          context: req.context,
          name: req.name,
          is_context: req.is_context
        }, data)
      if new_entity.exists? # exists? means is already saved
        status 405 # Can't post it, its already there bro
      else
        if new_entity.persist_recursively
          status 200
        else
          status 500
        end
      end
    end

    put '*' do
      # TODO Implement overwriting entity
    end

    delete '*' do
      req = Request.new(request)
      index_key = Entity.request_index_key(req)
      ent = Entity.find(index_key)
      if !ent
        status 404
      else
        if ent.delete
          status 200
        else
          status 500
        end
      end
    end
  end
end
