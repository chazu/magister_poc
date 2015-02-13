require 'spec_helper'

include Magister::Request

describe Request do

  it 'should have a path' do
    request = double("request", path: "/")
    context = Request.new(request)
    expect(context.context).to eq(["root"])
  end

  it 'should store the name separate from the context' do
    request = double("request", path: "/foobar")
    context = Request.new(request)
    expect(context.context).to eq(["root"])
    expect(context.name).to eq("foobar");
  end

  it 'should append a path component' do
    request = double("request", path: "/foo/bar")
    context = Request.new(request)
    expect(context.context).to eq(["root", "foo"])
    expect(context.name).to eq("bar")
  end

  it 'should append multiple path components' do
    request = double("request", path: "/foo/baz/quux/bar")
    context = Request.new(request)
    expect(context.context).to eq(["root", "foo", "baz", "quux"])
    expect(context.name).to eq("bar")
  end
end
