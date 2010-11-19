require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe TokensController do
  describe 'routing' do
    it 'routes / to the new action' do
      {:get => '/'}.should route_to(:controller => 'tokens', :action => 'new')
    end

    it 'routes a POST to /tokens to the create action' do
      {:post => '/tokens'}.should route_to(:controller => 'tokens', :action => 'create')
      tokens_path.should == '/tokens'
    end

    it 'routes a GET to /tokens/:id to the show action' do
      {:get => '/tokens/foo'}.should route_to(:controller => 'tokens', :action => 'show', :id => 'foo')
      token_path('foo').should == '/tokens/foo'
    end
  end

  describe '#new' do
    it 'renders the new token template' do
      get :new
      response.should render_template('tokens/new')
    end
  end

  describe '#create' do
    before(:each) do
      post :create, :token => {:name => 'A New Token'}
      Token.count.should == 1
      @token = Token.last
    end

    it 'creates a new token with the specified name' do
      @token.name.should == 'A New Token'
    end

    it 'redirects to the show action for the new token' do
      response.should redirect_to(token_path(@token))
    end
  end

  describe '#show' do
    before(:each) do
      @token = mock_model('Token')
      Token.stub!(:find => @token)
      get :show, :id => 'foo'
    end

    it 'renders the token template' do
      response.should render_template('tokens/show')
    end

    it 'assigns the specified token to the template' do
      assigns(:token).should == @token
    end
  end
end
