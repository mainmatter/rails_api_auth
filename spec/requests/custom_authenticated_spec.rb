describe 'a custom authenticated route' do
  subject { get '/custom-authenticated', {}, headers }

  let(:account) { create(:account) }
  let(:login)   { create(:login, account: account) }
  let(:headers) do
    { 'Authorization' => "Bearer #{login.oauth2_token}" }
  end

  context 'when the block returns true' do
    let(:account) { create(:account, first_name: 'user x') }

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

  context 'when the block returns false' do
    it 'responds with status 401' do
      subject

      expect(response).to have_http_status(401)
    end

    it 'responds with an empty body' do
      subject

      expect(response.body.strip).to be_empty
    end
  end
end
