describe 'an access-once route' do
  subject { get '/access-once', {}, headers }

  let(:login) { create(:login) }
  let(:headers) do
    { 'Authorization' => "Bearer #{login.single_use_oauth2_token}" }
  end

  context 'when a valid Bearer token is present' do
    it 'assigns the authenticated login to @current_login' do
      subject

      expect(assigns[:current_login]).to eq(login)
    end

    it "responds with the actual action's status" do
      subject

      expect(response).to have_http_status(200)
    end

    it "responds with the actual action's body" do
      subject

      expect(response.body).to eql('zuper content')
    end

    it "changes the login's single_use_oauth2_token" do
      expect { subject }.to change { login.reload.single_use_oauth2_token }
    end
  end

  shared_examples 'when access is not allowed' do
    it 'does not assign the authenticated login to @current_login' do
      subject

      expect(assigns[:current_login]).to be_nil
    end

    it 'responds with status 401' do
      subject

      expect(response).to have_http_status(401)
    end

    it 'responds with an empty body' do
      subject

      expect(response.body.strip).to be_empty
    end
  end

  context 'when accessed a second time with the same token' do
    before do
      get '/access-once', {}, headers
    end

    it_behaves_like 'when access is not allowed'
  end

  context 'when no valid Bearer token is present' do
    let(:headers) { {} }

    it_behaves_like 'when access is not allowed'
  end
end
