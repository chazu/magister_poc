module Magister
  describe TransformerRegistry do

    it 'should be a singleton' do
      expect(TransformerRegistry.instance).to eq(TransformerRegistry.instance)
    end

    context 'initialize_register' do

      test_index = {
        "/_/passthrough"                        => {},
        "/chimichangas"                         => {},
        "fnord"                                 => {},
        "/_/static"                             => {},
        "/god_help_me"                          => {},
        "/this_isnt_good_for_me/_/transformers" => {}
      }

      it 'should respond' do
        expect(TransformerRegistry).to respond_to(:initialize_register)
      end

      it 'should ask for all the keys from the index' do
        Magister::Config.set_index test_index
        expect(test_index).to receive(:keys).and_return(test_index.keys)
        TransformerRegistry.initialize_register
      end
    end
  end
end
