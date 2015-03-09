include Magister::Helpers

describe Helpers do

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

end
