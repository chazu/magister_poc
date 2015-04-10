include Magister::Helpers

describe Magister::Helpers do
  
  context 'expand_index_key' do
    it 'should expand into a list of index keys' do
      index_key_to_expand = "/this/is/my/index/key"

      expect(expand_index_key(index_key_to_expand)).to eq([
                                                            "/",
                                                            "/this",
                                                            "/this/is",
                                                            "/this/is/my",
                                                            "/this/is/my/index",
                                                            "/this/is/my/index/key"
                                                          ])
    end
    it 'should not differentiate when the entity is a context' do
      index_key_to_expand = "/this/is/my/index/key/"

      expect(expand_index_key(index_key_to_expand)).to eq([
                                                            "/",
                                                            "/this",
                                                            "/this/is",
                                                            "/this/is/my",
                                                            "/this/is/my/index",
                                                            "/this/is/my/index/key"
                                                          ])
    end
  end

  context "context_exists" do
    create_test_entity({
                         :context => ["fnord"],
                         :name => "foo",
                         :is_context => true,
                         :data => nil
                       })

    it 'should return true if context is in index' do
      expect(context_exists("/fnord")).to eq(true)
    end

    it 'should return false if context is not in index' do
      expect(context_exists("/blarg")).to eq(false)
    end
  end

  context 'to_sexp' do
    it "should convert an array into a list" do
      test_array = ["hello", "heist"]
      converted = to_sexp(test_array)
      inject_data converted, "test_array"
      
      expect(converted).to be_instance_of Heist::Runtime::Cons
      expect(@@runtime.send(:eval, "(assert-equal test_array '(\"hello\" \"heist\")) ")).to eq(true)
    end

    it "should convert a nested array" do
      test_array = ["hello", ["there", "heist"]]
      converted = to_sexp(test_array)
      inject_data converted, "test_array"
      
      expect(converted).to be_instance_of Heist::Runtime::Cons
      expect(@@runtime.send(:eval, "(assert-equal test_array '(\"hello\" (\"there\" \"heist\"))) ")).to eq(true)
    end

    it "should convert a nested hash to an alist" do
      test_hash = {
        hello: "heist",
        how: "you doing",
        today: { fine: "thank you", for_asking: "dear" }
      }
      converted = to_sexp(test_hash)
      inject_data converted, "test_hash"

      sexp_for_alist = "'((hello . \"heist\")
                          (how . \"you doing\")
                          (today . ((fine . \"thank you\")
                                    (for_asking . \"dear\"))
                         ))"
      expression = <<EXPRESSION
(assert-equal-stringwise test_hash #{sexp_for_alist})
EXPRESSION
      
      expect(runtime_eval(expression)).to eq(true)
    end

    it "should convert a hash to an alist" do
      test_hash = {
        hello: "heist",
        how: "you doing",
        today: 1
      }
      converted = to_sexp(test_hash)
      inject_data converted, "test_hash"

      expression = """
(assert-equal-stringwise test_hash '(
(hello . \"heist\")
(how . \"you doing\")
(today . 1)
))
"""
      expect(runtime_eval(expression)).to eq(true)
    end
  end

  context "from_sexp" do
    it "should convert an atom to a symbol" do
      expression = :foo
      inject_data expression, "test"
      ruby_handle = runtime_eval("test")

      result = from_sexp(ruby_handle)
      expect(ruby_handle).to be_instance_of(Heist::Runtime::Identifier)
      expect(result).to be_instance_of(Symbol)
      
    end

    it "should convert a list to an array" do
      array = ["foo", :bar, 1]
      sexp = to_sexp(array)
      result = from_sexp(sexp)

      expect(sexp).to be_instance_of Heist::Runtime::Cons
      expect(result).to be_instance_of Array
    end

    it "should convert a nested list to a nested array" do
      array = ["foo", :bar, [:baz, "quux", 3]]
      sexp = to_sexp(array)
      result = from_sexp(sexp)

      expect(sexp).to be_instance_of Heist::Runtime::Cons
      expect(result).to be_instance_of Array
      expect(result[2]).to be_instance_of Array
    end

    it "should convert an alist into a hash" do
      hash = {foo: :bar, baz: "quux"}
      sexp = to_sexp(hash)
      result = from_sexp(sexp)

      expect(sexp).to be_instance_of Heist::Runtime::Cons
      expect(result).to be_instance_of Hash
    end

      it "should handle nested hashes" do
      hash = {foo: :bar, baz: {quux: "aw yiss", hrunkner: "fnord" }}
      sexp = to_sexp(hash)
      result = from_sexp(sexp)

      expect(sexp).to be_instance_of Heist::Runtime::Cons
      expect(result).to be_instance_of Hash
      expect(result[:baz]).to be_instance_of Hash
    end
end
end
