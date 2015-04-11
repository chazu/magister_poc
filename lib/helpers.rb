require 'heist'

module Magister
  module Helpers

    def context_array_to_index_key(context_array)
      "/" + context_array.join("/")
    end
    
    def context_exists index_key
      if index_key == "/"
        true
      else
        Magister::Config.index.keys.include? index_key and
          Magister::Config.index[index_key] and
          Magister::Config.index[index_key][:_isContext]
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

    def list_append(runtime, cons, new)
    end
    
    def expand_index_key index_key
      if index_key == "/"
        # TODO This be jankyyyyy
        ["/"]
      else
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

    # Take a data structure (string, array or hash) and make it recursively into a Heist
    # data structure (string, list or alist)
    def to_sexp obj
      case 
      when obj.class == Array
        mutant = obj.map { |element| to_sexp(element) }
        Heist::Runtime::Cons.construct(mutant)
      when obj.class == Hash
        mutant = obj.inject([]) do |memo, (key, value)|
          cons = Heist::Runtime::Cons.new(key, to_sexp(value))
          memo << cons
        end
        Heist::Runtime::Cons.construct(mutant)
      when obj.class == Heist::Runtime::Cons
        Heist::Runtime::Cons obj.car, to_sexp(obj.cdr)
      else
        obj
      end
    end

    # Take a heist data structure (string, list or alist) and recursively make it into a ruby
    # data structure (string, array or hash)
    def from_sexp obj
      case
      when obj.class == Heist::Runtime::Identifier
        obj.to_ruby
      when obj.class == Heist::Runtime::Cons
        if obj.all? { |element| element.respond_to?("pair?") && element.pair? } #Its an alist!
          obj.inject({}) do |memo, pair|
            memo[pair.car] = from_sexp(pair.cdr)
            memo
          end
        else
          obj.to_ruby
        end
      else
        obj
      end
    end
  end
end
