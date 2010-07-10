require 'test_helper'

class CreateTokenTest < ActionDispatch::IntegrationTest
  fixtures :all

  test "create a new token" do
    user = new_session
    user.goes_to_homepage
    user.creates_new_token 'My new token'
    user.should_be_on_token_page 'my-new-token'
  end

  test "navigate directly to new token" do
    token = Token.create!(:name => 'An existing token')
    user = new_session
    user.goes_to_token_page token.slug
    user.should_be_on_token_page token.slug
  end

  test "create new token by navigating directly to it" do
    user = new_session
    user.goes_to_token_page 'created-on-visit'
    user.should_be_on_token_page 'created-on-visit'
  end

  private

  module VirtualTokenSessionDSL
    def goes_to_homepage
      get '/'
      assert_response :success
      assert_template 'tokens/new'
    end

    def creates_new_token(name)
      post '/tokens', :token => {:name => name}
      assert_response :redirect
      follow_redirect!
      should_be_on_token_page guess_token_id(name)
    end

    def goes_to_token_page(id)
      get "/tokens/#{id}"
    end

    def should_be_on_token_page(id)
      assert_response :success
      assert_template 'tokens/show'
      assert_equal Token.find(id), assigns[:token]
    end

    def guess_token_id(name)
      Token.generate_slug(name)
    end
  end

  def new_session
    open_session do |sess|
      sess.extend VirtualTokenSessionDSL
      yield sess if block_given?
    end
  end
end
