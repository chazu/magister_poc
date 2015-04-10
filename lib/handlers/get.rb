
module Magister
  module API
    module GetHandler
      def self.included base
        base.get '*' do

          req = Request.new(request)
          index_key = Entity.request_index_key(req)
          ent = Entity.find(index_key)

          #if ent
            status 200
            transformer = Magister::TransformerRegistry.transformer_for_request(req)
            transformer.inject_request(req)
            transformer.set_entity ent
            response = transformer.evaluate
            body response || ""
          # else
          #   status 404
          # end
        end
      end
    end
  end
end
