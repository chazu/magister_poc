include Magister::Helpers

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

  context "context_exists" do
    let(:index_double) { double("index", keys: ["/", "/foo", "/foo/bar/"]) }

    before do
      Magister::Config.set_index index_double
    end

    it 'should return true if context is in index' do
      expect(index_double).to receive(:keys).and_return(["/", "/foo", "/foo/bar"])
      expect(index_double).to receive(:[]).with("/foo").and_return({"_isContext" => true})
      expect(context_exists("/foo")).to eq(true)
    end

    it 'should return false if context is not in index' do
      expect(index_double).to receive(:keys).and_return(["/", "/foo", "/foo/bar"])
      expect(context_exists("/blarg")).to eq(false)
    end
  end

end
