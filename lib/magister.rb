require './lib/request.rb'
require './lib/entity.rb'

module Magister
  include Magister::Request
  include Magister::Entity
end
