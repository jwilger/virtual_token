require 'test_helper'

class TokenTest < ActiveSupport::TestCase
  test ".generate_slug should return lowercase, dasherized version of token name" do
    assert_equal 'the-slug-loo0ks-like-this',
      Token.generate_slug("@The #sluG   loO0ks#!$% like THIS!")
  end

  test ".find will return object where slug matches input" do
    t = Token.create!(:name => 'Foo Bar')
    assert_equal t, Token.find(t.slug)
  end

  test ".find will fall back to id if no slug matches" do
    t = Token.create!(:name => 'Foo Bar')
    assert_equal t, Token.find(t.id)
  end

  test "slug is set on create based on token name" do
    t = Token.create!(:name => 'Foo Bar')
    assert_equal Token.generate_slug('Foo Bar'), t.slug
  end

  test '#to_param returns slug' do
    t = Token.create!(:name => 'Foo Bar')
    assert_equal t.slug, t.to_param
  end
end
