describe Login do
  it 'belongs to the configured user model' do
    expect(subject).to belong_to(:account).with_foreign_key(:user_id)
  end

  subject { Login.new(identification: 'test@example.com', oauth2_token: 'token', single_use_oauth2_token: 'oldtoken') }

  describe 'validations' do
    before do
      allow_any_instance_of(Login).to receive(:ensure_oauth2_token).and_return(true)
      allow_any_instance_of(Login).to receive(:assign_single_use_oauth2_token).and_return(true)
    end

    it { is_expected.to validate_presence_of(:identification) }
    it { is_expected.to validate_uniqueness_of(:identification) }
    it { is_expected.to validate_uniqueness_of(:oauth2_token) }
    it { is_expected.to validate_uniqueness_of(:single_use_oauth2_token) }
  end

  it 'validates presence of either password or Facebook UID' do
    login = described_class.new(identification: 'test@example.com', oauth2_token: 'token')

    expect(login).to_not be_valid
  end

  it "doesn't validate presence of password when Facebook UID is present" do
    login = described_class.new(identification: 'test@example.com', oauth2_token: 'token', uid: '123', provider: 'facebook')

    expect(login).to be_valid
  end

  it "doesn't validate presence of Facebook UID  when password is present" do
    login = described_class.new(identification: 'test@example.com', oauth2_token: 'token', password: '123')

    expect(login).to be_valid
  end

  describe '#refresh_oauth2_token!' do
    subject { described_class.new(oauth2_token: 'oldtoken') }

    before do
      allow(subject).to receive(:save!)
    end

    it 'force-resets the oauth2 token' do
      expect { subject.refresh_oauth2_token! }.to change(subject, :oauth2_token)
    end

    it 'saves the model' do
      expect(subject).to receive(:save!)

      subject.refresh_oauth2_token!
    end
  end

  describe '#refresh_single_use_oauth2_token!' do
    subject { described_class.new(single_use_oauth2_token: 'oldtoken') }

    before do
      allow(subject).to receive(:save!)
    end

    it 'force-resets the single oauth2 token' do
      expect { subject.refresh_single_use_oauth2_token! }.to change(subject, :single_use_oauth2_token)
    end

    it 'saves the model' do
      expect(subject).to receive(:save!)

      subject.refresh_single_use_oauth2_token!
    end
  end
end
