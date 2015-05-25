module Magister
  module DefaultTransformers
    class DefaultTransformerJson < Magister::Transformer
      # Accepts Anything - returns application/text
      def initialize
        transform = Entity.new({
                                 context: ["_", "transformers", "default_json"],
                                 name: "transform",
                                 is_context: false
                               }, <<HERE
(define context-with-name (string-append (cdr (assoc "context" request))
                                           "/"
                                           (cdr (assoc "name" request))))

(define target-entity (find-entity context-with-name))

(if target-entity
(json-encode (entity-data target-entity)))
HERE
                              )

        meta = Entity.new({
                            context: ["_", "transformers", "default_json"],
                            name: "meta",
                            is_context: false
                          }, <<HERE
(transforms "*/*")
(returns "application/json")
(verbs "GET")
;;(deps)
HERE
                         )

        config = Entity.new({
                              context: ["_", "transformers", "default_json"],
                              name: "config",
                              is_context: false
                            }, <<HERE
"Nothin' to see here, folks!"
HERE
                           )

        [transform, meta, config].each do |x|
          x.persist_recursively
        end


        super Entity.find("/_/transformers/default_json")
      end
    end
  end
end
