include Helpers

describe Helpers do

  context 'expand_index_key' do

    it 'should expand into a list of index keys' do
      index_key_to_expand = "/this/is/my/index/key"

      expect(expand_index_key(index_key_to_expand)).to eq([
          "/",
          "/this/",
          "/this/is/",
          "/this/is/my/",
          "/this/is/my/index/",
          "/this/is/my/index/key"
        ])
    end
    it 'should understand when the entity is a context' do
      index_key_to_expand = "/this/is/my/index/key/"

      expect(expand_index_key(index_key_to_expand)).to eq([
          "/",
          "/this/",
          "/this/is/",
          "/this/is/my/",
          "/this/is/my/index/",
          "/this/is/my/index/key/"
        ])
    end
  end
end