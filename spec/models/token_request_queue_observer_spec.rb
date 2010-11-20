require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe TokenRequestQueueObserver do
  shared_examples_for :queue_updater do
    it 'calls Token#update_queue on the associated Token' do
      token = mock_model('Token')
      token.should_receive(:update_queue)
      request = mock_model('TokenRequest', :token => token)
      observer = TokenRequestQueueObserver.instance
      observer.send(@callback_name, request)
    end
  end

  describe '#after_create' do
    before(:each) do
      @callback_name = :after_create
    end
    it_should_behave_like :queue_updater
  end

  describe '#after_destroy' do
    before(:each) do
      @callback_name = :after_destroy
    end
    it_should_behave_like :queue_updater
  end
end
