require './lib/magister.rb'

require 'sinatra'
require 'pry'

module Magister

  class MagisterApp < Sinatra::Application
    get '*' do
      context = Context::Context.new(request)
      context.path.to_s
    end
  end
end
