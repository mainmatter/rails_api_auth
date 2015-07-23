describe 'Authenticated route' do
  let!(:login) { create(:login) }
  let(:headers) do
    {
      'Authorization': "Bearer #{login.oauth2_token}"
    }
  end

  subject { get '/authenticated', {}, headers }

  it 'assigns login found to @current_login' do
    subject

    assigns[:current_login] = login
  end

  it '200' do
    subject

    expect(response.status).to eq 200
  end

  it 'lets the action get rendered' do
    subject

    expect(response.body).to eql 'zuper content'
  end

  context 'no token' do

    subject { get '/authenticated' }

    it '401' do
      subject

      expect(response.status).to eq 401
    end

    it 'responds with an empty body' do
      subject

      expect(response.body).to be_empty
    end
  end
end
