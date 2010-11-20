require File.expand_path(File.join(File.dirname(__FILE__), '..', 'spec_helper'))

describe TokensController do
  include Devise::TestHelpers

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

  context 'anonymous user' do
    describe '#new' do
      it 'requires an authenticated user' do
        get :new
        response.should redirect_to(new_user_session_path)
      end
    end

    describe '#create' do
      it 'requires an authenticated user' do
        post :create
        response.should redirect_to(new_user_session_path)
      end
    end

    describe '#show' do
      it 'requires an authenticated user' do
        get :create, :id => 'foo'
        response.should redirect_to(new_user_session_path)
      end
    end
  end

  context 'authenticated user' do
    before(:each) do
      s_user = stub('User')
      request.env['warden'] = stub('Warden', :authenticate => s_user, :authenticate! => s_user)
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
        Token.stub!(:find_by_slug! => @token)
      end

      it 'renders the token template' do
        get :show, :id => 'foo'
        response.should render_template('tokens/show')
      end

      it 'assigns the specified token to the template' do
        Token.should_receive(:find_by_slug!).with('foo').and_return(@token)
        get :show, :id => 'foo'
        assigns(:token).should == @token
      end

      it 'assigns a new token request to the template' do
        get :show, :id => 'foo'
        assigns(:new_token_request).should be_kind_of(TokenRequest)
        assigns(:new_token_request).should be_new_record
      end
    end
  end
end
