require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe TokenRequest do
  describe '#claim_granted' do
    it 'updates the #claim_granted_at attribute if it is not already set' do
      user = mock_model('User').as_null_object
      token = mock_model('Token').as_null_object
      request = TokenRequest.new(:user => user, :token => token)
      Timecop.freeze
      time = Time.now
      request.claim_granted
      Timecop.return
      request.claim_granted_at.should == time
    end

    it 'does not update the #claim_granted_at attribute is is is already set' do
      time = 3.hours.ago
      user = mock_model('User').as_null_object
      token = mock_model('Token').as_null_object
      request = TokenRequest.new(:user => user, :token => token, :claim_granted_at => time)
      request.claim_granted
      request.claim_granted_at.should == time
    end
  end
end
