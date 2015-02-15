describe "GET Endpoint" do

  it 'should return 404 if entity does not exist' do
    get '/this/entity/doesnt/exist'
    expect(last_response.status).to eq 404
  end

  it 'should return 200 if entity does exist' do
    get '/'
    expect(last_response.status).to eq 200
  end
end
