module Magister
  describe TransformerRegistry do

    it 'should be a singleton' do
      expect(TransformerRegistry.instance).to eq(TransformerRegistry.instance)
    end


    context 'initialize_register' do

      test_index = {
        "/_/transformers"                       => {},
        "/chimichangas"                         => {},
        "fnord"                                 => {},
        "/_/static"                             => {},
        "/god_help_me/_/transformers/foo"       => {},
        "/this_isnt_good_for_me/_/transformers" => {}
      }

      it 'should respond' do
        expect(TransformerRegistry).to respond_to(:initialize_register)
      end

      it 'should ask for all the keys from the index' do
        Magister::Config.set_index test_index
        expect(test_index).to receive(:keys).at_least(:once).and_return(test_index.keys)
        TransformerRegistry.initialize_register
      end

      context 'transformer_context_index_keys' do

        it 'should get all the ones that end in /_/transformers' do
          Magister::Config.set_index test_index
          expect(test_index).to receive(:keys).at_least(:once).and_return(test_index.keys)

          res = TransformerRegistry.transformer_context_index_keys
          expect(res).to include("/_/transformers")
          expect(res).to include("/this_isnt_good_for_me/_/transformers")
          expect(res.length).to eq(2)
        end
      end

      context 'transformer_index_keys_in_contexts' do
        it 'should return all transformer contexts WITHIN the designated directories' do
          Magister::Config.set_index test_index
          expect(test_index).to receive(:keys).at_least(:once).and_return(test_index.keys)

          res = TransformerRegistry.transformer_context_index_keys
          expect(TransformerRegistry.transformer_index_keys_in_contexts(res)).to include('TODO Create helpers to create and teardown actual entities before and after tests.')
        end
      end
    end
  end
end
