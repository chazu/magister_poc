module Magister
  module Helpers

    def context_exists index_key
      if index_key == "/"
        true
      else
        Magister::Config.index.keys.include? index_key and
          Magister::Config.index[index_key] and
          Magister::Config.index[index_key]["_isContext"]
      end
    end

    def entity_exists index_key
      if index_key == "/"
        true
      else
        Magister::Config.index.keys.include? index_key and
          Magister::Config.index[index_key]
      end
    end

    def highest_extant_context_for_key index_key
      # TODO Avoid looping for the root context? Its not THAT expensive is it?
      expanded_keys = expand_index_key index_key

      exists = true
      val = nil
      expanded_keys.each do |key|
        if !context_exists key
          break
        end
        val = key
      end
      val
    end

    # Takes an index key and returns an array of
    # index keys describing the root node all the way down to the
    # final context or entity
    def expand_index_key index_key
      split_key = index_key.split("/")
      split_key
      injected = split_key.inject([]) do |memo, component|
        last_one = memo.last
        val = (component == "" ? "/" : component)
        if !last_one
          memo << val
        else
          memo << last_one + val + "/"
        end
      end

      # TODO This is hinky as fuck, plz fix
      trimmed = injected.map do |x|
        if not x == "/"
          x[-1] = ""
        end
        x
      end
      trimmed
    end
  end
end
