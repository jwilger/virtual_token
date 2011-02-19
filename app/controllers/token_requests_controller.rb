class TokenRequestsController < ApplicationController
  skip_before_filter :authenticate_user!, :only => :index

  def index
    redirect_to token_path(params[:token_id])
  end

  def create
    TokenRequest.create!(token_params)
    redirect_to token_path(params[:token_id])
  rescue ActiveRecord::RecordInvalid => e
    @token = token_params[:token]
    @new_token_request = e.record
    render 'tokens/show'
  end

  def destroy
    TokenRequest.destroy(params[:id])
    redirect_to token_path(params[:token_id])
  end
  
  def move
    token_request = TokenRequest.find(params[:id])
    token_request.move(params[:where])
    redirect_to token_path(params[:token_id])
  end

  private

  def token_params
    return @token_params unless @token_params.nil?
    p = params[:token_request] || {}
    p.merge!(:token => Token.find_by_slug!(params[:token_id]))
    p.merge!(:user => current_user)
    @token_params = p
  end
end
