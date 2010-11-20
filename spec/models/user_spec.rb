require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe User do
  describe '#to_s' do
    it 'returns "name <email>"' do
      u = User.new(:name => 'Bilbo Baggins', :email => 'bilbo@middle-earth.net')
      u.to_s.should == "Bilbo Baggins <bilbo@middle-earth.net>"
    end
  end
end
