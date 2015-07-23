describe 'an authenticated route' do
  subject { get '/authenticated', {}, headers }

  let(:headers) { {} }

  context 'when a valid Bearer token is present' do

    let(:login) { create(:login) }
    let(:headers) do
      { 'Authorization': "Bearer #{login.oauth2_token}" }
    end

    it 'assigns the authenticated login to @current_login' do
      subject

      expect(assigns[:current_login]).to eq(login)
    end

    it "responds with the actual action's status" do
      subject

      expect(response).to have_http_status(201)
    end

    it "responds with the actual action's body" do
      subject

      expect(response.body).to eql('zuper content')
    end

  end

  context 'when no valid Bearer token is present' do

    it 'responds with status 401' do
      subject

      expect(response).to have_http_status(401)
    end

    it 'responds with an empty body' do
      subject

      expect(response.body).to be_empty
    end
  end
end
