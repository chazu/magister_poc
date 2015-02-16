include Magister

describe Request do

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
end
