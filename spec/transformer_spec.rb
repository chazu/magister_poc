include Magister

describe Transformer do
  context 'execute' do

    it 'should run some lisp code' do
      transformer = Transformer.new
      expect(transformer.execute).to eq("hello!")
    end
  end
end
