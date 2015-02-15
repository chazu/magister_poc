include Magister::Entity
include Magister::Request
describe Entity do

  it 'should take a request for initialization' do
    request = double("request", path: "/foo", env: {})
    req = Request.new(request)

    expect { entity = Entity.new(req, nil) }.not_to raise_error
  end

  context 'index key' do
    it 'should have an index_key method' do
      request = double("request", path: "/foo", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity).to respond_to :index_key
    end

    it 'should return a slash for root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.index_key).to eq("/");
    end

    it 'should append the name of the entity requested' do
      request = double("request", path: "/foo", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.index_key).to eq("/foo");
    end

    it 'should include context path' do
      request = double("request", path: "/foo/bar/baz", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.index_key).to eq("/foo/bar/baz");
    end

    it 'should not include a terminal slash if entity is context' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.index_key).to eq("/foo/bar/baz");
    end
  end

  context 'exists?' do
    it 'should always return true for the root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.exists?).to eq(true)
    end
  end

  context 'is_context?' do
    it 'should always return true for root entity' do
      request = double("request", path: "/", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.is_context?).to eq(true)
    end

    it 'should return false for non-context requests' do
      request = double("request", path: "/foo/bar", env: {})
      req = Request.new(request)
      entity = Entity.new(req, nil)
      expect(entity.is_context?).to eq(false)
    end

    it 'should return true for context requests based on header' do
      request = double("request", path: "/foo/bar/baz", env: {'HTTP_MAGISTER_IS_CONTEXT' => 'true'})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.is_context?).to eq(true)
    end

    it 'should return true for context requests based on terminating slash' do
      request = double("request", path: "/foo/bar/baz/", env: {})
      req = Request.new(request)

      entity = Entity.new(req, nil)
      expect(entity.is_context?).to eq(true)
    end
  end
end
