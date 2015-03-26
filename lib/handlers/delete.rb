module Magister
  module API
    module DeleteHandler
      def self.included base
        base.delete '*' do
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
  end
end
