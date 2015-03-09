describe "DELETE Endpoint" do

  it 'should return 404 if entity does not exist' do
    delete '/this/entity/shouldnt/exist'
    expect(last_response.status).to eq 404
  end

  it 'should return 200 if the entity does exist and can be deleted' do
    ent_double = double('Entity');
    expect(Magister::Entity).to receive(:find).and_return(ent_double)
    expect(ent_double).to receive(:delete).and_return(true)
    delete '/this/entity/should/exist'
    expect(last_response.status).to eq 200    
  end
end
