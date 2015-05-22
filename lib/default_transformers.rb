module Magister
  module DefaultTransformers
    class DefaultTransformerText < Magister::Transformer
      # Accepts Anything - returns application/text
      def initialize
        transform = Entity.new({
                                 context: ["_", "transformers", "default_text"],
                                 name: "transform",
                                 is_context: false
                               }, <<HERE
(define context-with-name (string-append (cdr (assoc "context" request))
                                           "/"
                                           (cdr (assoc "name" request))))

(define target-entity (find-entity context-with-name))

(if target-entity
(entity-data target-entity))
HERE
                              )

        meta = Entity.new({
                            context: ["_", "transformers", "default_text"],
                            name: "meta",
                            is_context: false
                          }, <<HERE
(meta
 '(transforms "*/*")
 '(returns "text/plain")
 '(verbs "GET")
 '("deps" ()))
HERE
                         )

        config = Entity.new({
                              context: ["_", "transformers", "default_text"],
                              name: "config",
                              is_context: false
                            }, <<HERE
"Nothin' to see here, folks!"
HERE
                           )

        [transform, meta, config].each do |x|
          x.persist_recursively
        end


        super Entity.find("/_/transformers/default_text")
      end
    end
  end
end
