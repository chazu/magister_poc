include Magister

describe Request do
  # TODO THIS is shit, fix it.
  it 'should have a path' do
    request = double("request", path: "/", env: {})
    mag_request = Request.new(request)
    expect(mag_request.context).to eq([])
  end

  it 'should store the name separate from the context' do
    request = double("request", path: "/foobar", env: {})
    mag_request = Request.new(request)
    expect(mag_request.context).to eq([])
    expect(mag_request.name).to eq("foobar");
  end

  it 'should append a path component' do
    request = double("request", path: "/foo/bar", env: {})
    mag_request = Request.new(request)
    expect(mag_request.context).to eq(["foo"])
    expect(mag_request.name).to eq("bar")
  end

  it 'should append multiple path components' do
    request = double("request", path: "/foo/baz/quux/bar", env: {})
    mag_request = Request.new(request)
    expect(mag_request.context).to eq(["foo", "baz", "quux"])
    expect(mag_request.name).to eq("bar")
  end

  context 'name' do
    # TODO
  end

  context 'as_hash' do
    it 'should return a hash' do
      request = double("request", path: "/foo/baz/quux/bar", env: {})
      mag_request = Request.new(request)

      expect(mag_request.as_hash).to be_instance_of(Hash)
    end

    it 'should have some keys' do
      request = double("request", path: "/foo/baz/quux/bar", env: {})
      mag_request = Request.new(request)

      hash = mag_request.as_hash
      expect(hash.keys).to include("context")
      expect(hash.keys).to include("name")
      expect(hash.keys).to include("is_context") # Who outside of Request#new needs this? Nobody...

      expect(hash["name"]).to eq("bar")
      expect(hash["context"]).to eq("/foo/baz/quux")
      expect(hash["is_context"]).to eq(false)
    end
  end
end
