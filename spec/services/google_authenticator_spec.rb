describe GoogleAuthenticator do
  include_context 'stubbed google requests'
  describe '#authenticate!' do
    let(:provider) { 'google' }
    let(:email) { 'email@gmail.com' }
    let(:google_data) do
      {
        sub: '1238190321',
        email: email
      }
    end

    let(:login) { double('login') }

    subject { described_class.new(auth_code).authenticate! }

    context 'when no login for the Google account exists' do
      let(:login_attributes) do
        {
          identification: google_data[:email],
          uid: google_data[:sub],
          provider: 'google'
        }
      end

      before do
        allow(Login).to receive(:create!).with(login_attributes).and_return(login)
      end

      it 'returns a login created from the Google account' do
        expect(subject).to eql(login)
      end
    end

    context 'when a login for the Google account exists already' do
      before do
        expect(Login).to receive(:where).with(identification: google_data[:email]).and_return([login])
        allow(login).to receive(:update_attributes!).with(uid: google_data[:sub], provider: provider)
      end

      it 'connects the login to the Google account' do
        expect(login).to receive(:update_attributes!).with(uid: google_data[:sub], provider: provider)

        subject
      end
    end
  end
end
