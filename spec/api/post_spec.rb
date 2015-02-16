describe "POST Endpoint" do

  context 'creating a context' do

    it 'shouldnt work on root context' do
    end

    it 'should return 200' do
      post '/lets/make/an/entity', foo: 'bar'

      expect(last_response.status).to eq 200
    end


  end
end
