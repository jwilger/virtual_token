class TokenRequestsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  def index
    redirect_to token_path(params[:token_id])
  end

  def create
    TokenRequest.create!(token_params)
    redirect_to token_path(params[:token_id])
  rescue ActiveRecord::RecordInvalid => e
    @token = Token.find(params[:token_id])
    @new_token_request = e.record
    render 'tokens/show'
  end

  private

  def token_params
    p = params[:token_request] || {}
    p.merge!(:token_id => params[:token_id])
    p.merge!(:user_id => current_user.id)
  end
end
