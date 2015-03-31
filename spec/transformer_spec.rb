include Magister

describe Transformer do
  #TODO Factor out the repetitive loading of transformers

  # context 'initialize' do

  #   it 'should take an entity in its constructor' do
  #     hello_entity = double('entity', data: File.read("./transformers/hello/transform"))
  #     expect(hello_entity).to receive(:index_key)

  #     hello_transformer = Transformer.new hello_entity
  #     expect(hello_transformer).to be_instance_of(Transformer)
  #   end
  # end

  # context 'evaluate' do
  #   it 'should execute the body of the transform file' do
  #     hello_entity = double('entity', data: File.read("./transformers/hello/transform"))
  #     expect(hello_entity).to receive(:index_key)

  #     hello_transformer = Transformer.new hello_entity
  #     expect(hello_transformer.evaluate).to eq("Hello Magister!")
  #   end
  # end

  # context 'inject_request' do
  #   it 'should bind variable "request" in the runtime' do
  #     hello_entity = double('entity', data: File.read("./transformers/hello/transform"))
  #     expect(hello_entity).to receive(:index_key)

  #     hello_transformer = Transformer.new hello_entity
  #     hello_transformer.inject_request "My Request!"
  #     expect(hello_transformer.runtime.eval("request")).to eq("My Request!")
  #   end
  # end
  context 'transformer_for_request' do
    # TODO
  end
end
