require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Token do
  describe '.generate_slug' do
    it 'returns the lowercase, dasherized version of the token name' do
      Token.generate_slug('@The #sluG   loO0ks#!$% like THIS!') \
        .should == 'the-slug-loo0ks-like-this'
    end
  end

  describe '.create' do
    it 'sets the slug based on the token name' do
      t = Token.create!(:name => 'Foo Bar')
      t.slug.should == Token.generate_slug('Foo Bar')
    end
  end

  describe '#to_param' do
    it 'returns the token slug' do
      t = Token.create!(:name => 'Foo Bar')
      t.to_param.should == t.slug
    end
  end

  describe '#claimed?' do
    context 'there are no requests for the token' do
      it 'should return false' do
        t = Token.new
        t.claimed?.should == false
      end
    end

    context 'there are one or more requests for the token' do
      it 'should return true' do
        t = Token.new
        t.requests << mock_model('TokenRequest', :set_token_target => nil)
        t.claimed?.should == true
      end
    end
  end

  describe '#has_queue?' do
    context 'when there are no token requests for this token' do
      it 'returns false' do
        t = Token.new
        t.has_queue?.should == false
      end
    end
  end

  describe '#update_queue' do
    it 'reloads the requests association' do
      token = Token.new
      token.should_receive(:requests).with(true).and_return([])
      token.update_queue
    end

    context '(when there are no requests)' do
      it 'sets claimed_at to nil' do
        token = Token.new(:claimed_at => Time.now)
        token.update_queue
        token.claimed_at.should be_nil
      end
    end

    context '(when there is at least one request)' do
      it 'sets claimed_at to the current time' do
        token = Token.new
        token.stub!(:requests => [mock_model('TokenRequest')])
        Timecop.freeze
        token.update_queue
        time = Time.now
        Timecop.return
        token.claimed_at.should == time
      end
    end
  end
end
