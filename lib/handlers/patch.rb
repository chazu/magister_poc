
module Magister
  module API
    module PatchHandler
      def self.included base
        base.patch '*' do
          # TODO Implement overwriting entity
        end
      end
    end
  end
end
