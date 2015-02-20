module Magister
  module Helpers
    def context_exists index_key
    end

    def highest_extant_context_for_key index_key
    end

    # Takes an index key and returns an array of
    # index keys describing the root node all the way down to the
    # final context or entity
    def expand_index_key index_key
      split_key = index_key.split("/")
      split_key
      injected = split_key.inject([]) do |memo, component|
        last_one = memo.last
        val = component == "" ? "/" : component
        if !last_one
          memo << val
        else
          memo << last_one + val + "/"
        end
      end
      if index_key[-1] != "/" # If the last bit is NOT a context
        injected[-1][-1] = "" # Remove the slash
      end
      injected
    end
  end
end
