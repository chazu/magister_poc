module Magister
  describe TransformerRegistry do

    it 'should be a singleton' do
      expect(TransformerRegistry.instance).to eq(TransformerRegistry.instance)
    end


    context 'initialize_register' do

        create_test_entity({:context => ["_", "transformers", "hello"],
        :name => 'transform',
        :is_context => false,
        :data => "hello"})

        create_test_entity({:context => ["this", "isnt", "good", "for", "me", "_", "transformers", "hiya"],
        :name => 'transform',
        :is_context => false,
        :data => "hello"})

      it 'should respond' do
        expect(TransformerRegistry).to respond_to(:initialize_register)
      end

      context 'transformer_context_index_keys' do

        it 'should get all the ones that end in /_/transformers' do
          res = TransformerRegistry.transformer_context_index_keys
          expect(res).to include("/_/transformers")
          expect(res).to include("/this/isnt/good/for/me/_/transformers")
          expect(res.length).to eq(2)
        end
      end

      context 'transformer_index_keys_in_contexts' do
        it 'should return all transformer contexts WITHIN the designated directories' do

          res = TransformerRegistry.transformer_context_index_keys
          expect(TransformerRegistry.transformer_index_keys_in_contexts(res)).to include({"name" => "/this/isnt/good/for/me/_/transformers/hiya"})
          expect(TransformerRegistry.transformer_index_keys_in_contexts(res)).to include({"name" => "/_/transformers/hello"})
        end
      end
    end
  end
end
