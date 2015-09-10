describe FacebookAuthenticator do
  include_context 'stubbed facebook requests'

  describe '#authenticate!' do
    let(:facebook_data) do
      {
        id:    '1238190321',
        email: email
      }
    end
    let(:email) { 'email@facebook.com' }
    let(:login) { double('login') }

    subject { described_class.new(auth_code).authenticate! }

    context 'when no login for the Facebook account exists' do
      let(:login_attributes) do
        {
          identification: facebook_data[:email],
          uid: facebook_data[:id],
          provider: 'facebook'
        }
      end

      before do
        allow(Login).to receive(:create!).with(login_attributes).and_return(login)
      end

      it 'returns a login created from the Facebook account' do
        expect(subject).to eql(login)
      end
    end

    context 'when a login for the Facebook account exists already' do
      before do
        expect(Login).to receive(:where).with(identification: facebook_data[:email]).and_return([login])
        allow(login).to receive(:update_attributes!).with(uid: facebook_data[:id], provider: 'facebook')
      end

      it 'connects the login to the Facebook account' do
        expect(login).to receive(:update_attributes!).with(uid: facebook_data[:id], provider: 'facebook')

        subject
      end
    end
  end
end
