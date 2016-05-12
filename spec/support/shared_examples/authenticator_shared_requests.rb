shared_examples 'a authenticator' do
  describe '#authenticate!' do
    let(:login) { double('login') }

    if described_class::PROVIDER.eql? 'edx'
      subject { described_class.new('user', auth_code).authenticate! }
    else
      subject { described_class.new(auth_code).authenticate! }
    end

    context "when no login for the #{described_class::PROVIDER} account exists" do
      let(:login_attributes) do
        {
          identification: authenticated_user_data[:email],
          uid: authenticated_user_data[uid_mapped_field.to_sym],
          provider: described_class::PROVIDER
        }
      end

      before do
        allow(Login).to receive(:create!).with(login_attributes).and_return(login)
      end

      it "returns a login created from the #{described_class::PROVIDER} account" do
        expect(subject).to eql(login)
      end
    end

    context "when a login for the #{described_class::PROVIDER} account exists already" do
      before do
        expect(Login).to receive(:where).with(identification: authenticated_user_data[:email]).and_return([login])
        allow(login).to receive(:update_attributes!).with(uid: authenticated_user_data[uid_mapped_field.to_sym], provider: described_class::PROVIDER)
      end

      it "connects the login to the #{described_class::PROVIDER} account" do
        expect(login).to receive(:update_attributes!).with(uid: authenticated_user_data[uid_mapped_field.to_sym], provider: described_class::PROVIDER)

        subject
      end
    end
  end
end
