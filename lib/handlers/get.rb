
module Magister
  module API
    module GetHandler
      def self.included base
        base.get '*' do
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
      end
    end
  end
end
