shared_examples 'API status success' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end
