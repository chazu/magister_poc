module Magister
  describe TransformerRegistry do

    it 'should be a singleton' do
      expect(TransformerRegistry.instance).to eq(TransformerRegistry.instance)
    end

    it 'should register transformers' do
    end

  end
end
