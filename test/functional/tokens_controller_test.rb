require 'test_helper'

class TokensControllerTest < ActionController::TestCase
  test "homepage should be new token page" do
    assert_recognizes({:controller => 'tokens', :action => 'new'}, '/')
  end

  test "#new should render the new token template" do
    get :new
    assert_response :success
    assert_template 'tokens/new'
  end

  test "#create should create new token and redirect to #show" do
    post :create, :token => {:name => 'A New Token'}
    assert_redirected_to token_path(Token.last)
  end

  test "#show should render the token template and assign the specified token" do
    token = Token.create!(:name => 'My token')
    get :show, :id => token.id
    assert_response :success
    assert_template 'tokens/show'
    assert_equal token, assigns[:token]
  end

  test "show should create new token using slug if it doesn't exist" do
    get :show, :id => 'a-new-token'
    assert_response :success
    assert_equal Token.find('a-new-token'), assigns[:token]
  end
end
