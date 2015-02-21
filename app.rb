require './lib/magister.rb'

require 'rufus-scheduler'
require 'sinatra'
require 'pry'


store = Magister::Store.new
Magister::Config.set_store store
Magister::Config.set_index Magister::Index.new store

scheduler = Rufus::Scheduler.new

scheduler.every '120s' do
  Magister.sync_index_to_store
end

puts "==="

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
          data = request.params["_magister_file"][:tempfile].read
        else
          data = request.body.gets
        end
      else
        data = nil
      end

      # Ensure context(s) exist (or can be created)
      
      new_entity = Entity.new({
          context: req.context,
          name: req.name,
          is_context: req.is_context
        }, data)
      if new_entity.exists? # exists? means is already saved
        status 405 # Can't post it, its already there bro
      else
        if new_entity.persist
          status 200
        else
          status 500
        end
      end
    end
  end
end
