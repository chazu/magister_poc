
module Magister
  module API
    module PostHandler
      def self.included base
        base.post '*' do
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
          # if new_entity.exists? # exists? means is already saved
          #   status 405 # Can't post it, its already there bro
          # else
            if new_entity.persist_recursively
              status 200
            else
              status 500
            end
          # end
        end
      end
    end
  end
end
