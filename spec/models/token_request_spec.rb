require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe TokenRequest do
  describe '#claim_granted' do
    let(:user) { mock_model('User').as_null_object }
    let(:token) { mock_model('Token').as_null_object }
    let(:request) { TokenRequest.new(:user => user, :token => token) }

    context 'the request has already been granted the claim' do
      before(:each) do
        request.stub!(:claim_granted? => true)
      end

      it 'does not update the #claim_granted_at attribute is is is already set' do
        time = 3.hours.ago
        request.claim_granted_at = time
        request.claim_granted
        request.claim_granted_at.should == time
      end

      it 'does not send the notification message' do
        TokenRequestNotification.should_not_receive(:claim_granted)
        request.claim_granted
      end
    end

    context 'the request has not already been granted the claim' do
      before(:each) do
        request.stub!(:claim_granted? => false)
      end

      it 'updates the #claim_granted_at attribute if it is not already set' do
        Timecop.freeze
        time = Time.now
        request.claim_granted
        Timecop.return
        request.claim_granted_at.should == time
      end

      it 'sends the notification message' do
        mail = mock('TokenRequestNotification')
        TokenRequestNotification.should_receive(:claim_granted) \
          .with(request).and_return(mail)
        mail.should_receive(:deliver)
        request.claim_granted
      end
    end
  end

  describe '#claim_granted?' do
    it 'returns true if claim_granted_at is set' do
      t = TokenRequest.new(:claim_granted_at => Time.now)
      t.claim_granted?.should == true
    end

    it 'returns false if claim_granted_at is nil' do
      t = TokenRequest.new
      t.claim_granted?.should == false
    end
  end
end
