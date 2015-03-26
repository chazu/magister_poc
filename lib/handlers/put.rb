
module Magister
  module API
    module PutHandler
      def self.included base
        base.put '*' do
          # TODO Implement overwriting entity
        end
      end
    end
  end
end
