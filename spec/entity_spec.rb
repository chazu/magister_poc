include Magister

def options_from_request(req)
    {
      context: req.context,
      name: req.name,
      is_context: req.is_context
    }
end

describe Entity do

  it 'should take a hash of options for initialization' do
    request = double("request", path: "/foo", env: {})
    req = Request.new(request)
    options = options_from_request(req)
    expect { entity = Entity.new(options, nil) }.not_to raise_error
  end

  context 'request_index_key' do
    it 'should return a slash for root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)
      result = Entity.request_index_key(req)
      expect(result).to eq("/");
    end

    it 'should append the name of the entity requested' do
      request = double("request", path: "/foo", env: {})
      req = Request.new(request)

      result = Entity.request_index_key(req)
      expect(result).to eq("/foo");
    end

    it 'should include context path' do
      request = double("request", path: "/foo/bar/baz", env: {})
      req = Request.new(request)

      options = options_from_request(req)
      result = Entity.request_index_key(req)
      expect(result).to eq("/foo/bar/baz");
    end

    it 'should not include a terminal slash if entity is context' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)

      options = options_from_request(req)
      result = Entity.request_index_key(req)
      expect(result).to eq("/foo/bar/baz");
    end
  end

  context 'name_from_index_key' do
    it 'should work for contexts' do
      key = "/this/is/a/context/"
      expect(Entity.name_from_index_key key).to eq("context")
    end

    it 'should work for non-contexts' do
      key = "/this/is/an/entity"
      expect(Entity.name_from_index_key key).to eq("entity")
    end

    it 'should return an empty string for root' do
      key = "/"
      expect(Entity.name_from_index_key key).to eq("")
    end
  end

  context 'index key' do
    it 'should have an index_key method' do
      request = double("request", path: "/foo", env: {})
      req = Request.new(request)
      options = options_from_request(req)

      entity = Entity.new(options, nil)
      expect(entity).to respond_to :index_key
    end

    it 'should return a slash for root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.index_key).to eq("/");
    end

    it 'should append the name of the entity requested' do
      request = double("request", path: "/foo", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.index_key).to eq("/foo");
    end

    it 'should include context path' do
      request = double("request", path: "/foo/bar/baz", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.index_key).to eq("/foo/bar/baz");
    end

    it 'should not include a terminal slash if entity is context' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.index_key).to eq("/foo/bar/baz");
    end
  end

  context 'exists?' do
    it 'should always return true for the root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.exists?).to eq(true)
    end
  end

  context 'is_context?' do
    it 'should always return true for root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.is_context?).to eq(true)
    end

    it 'should return false for non-context requests' do
      request = double("request", path: "/foo/bar", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.is_context?).to eq(false)
    end

    it 'should return true for context requests based on header' do
      request = double("request", path: "/foo/bar/baz", env: {'HTTP_MAGISTER_IS_CONTEXT' => 'true'})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.is_context?).to eq(true)
    end

    it 'should return true for context requests based on terminating slash' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.is_context?).to eq(true)
    end
  end

  context 'data' do
    it 'should return nil for a context' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)
      options = options_from_request(req)
      entity = Entity.new(options, nil)
      expect(entity.data).to eq(nil)
    end
  end
end
