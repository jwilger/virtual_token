require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe Token do
  describe '.generate_slug' do
    it 'returns the lowercase, dasherized version of the token name' do
      Token.generate_slug('@The #sluG   loO0ks#!$% like THIS!') \
        .should == 'the-slug-loo0ks-like-this'
    end
  end

  describe '.find' do
    it 'returns the token with the specified slug' do
      t = Token.create!(:name => 'Foo Bar')
      Token.find(t.slug).should == t
    end

    it 'returns the token with the matching id if no match found for slug' do
      t = Token.create!(:name => 'Foo Bar')
      Token.find(t.id).should == t
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
  end

  describe '#has_queue?' do
    context 'when there are no token requests for this token' do
      it 'returns false' do
        t = Token.new
        t.has_queue?.should == false
      end
    end
  end
end
