require 'spec_helper'

include Magister::Context

describe Context do

  it 'should have a path' do
    request = double("request", path: "/")
    context = Context.new(request)
    expect(context.path).to eq([:root_context])
  end

  it 'should ignore the name' do
    request = double("request", path: "/foobar")
    context = Context.new(request)
    expect(context.path).to eq([:root_context])
  end

  it 'should append a path component' do
    request = double("request", path: "/foo/bar")
    context = Context.new(request)
    expect(context.path).to eq([:root_context, "foo"])
  end

  it 'should append multiple path components' do
    request = double("request", path: "/foo/baz/quux/bar")
    context = Context.new(request)
    expect(context.path).to eq([:root_context, "foo", "baz", "quux"])
  end
end
