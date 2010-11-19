class TokensController < ApplicationController
  def new
    @token = Token.new
  end

  def create
    token = Token.create!(params[:token])
    redirect_to token_path(token)
  rescue ActiveRecord::RecordInvalid => e
    @token = e.record
    render :action => :new
  end

  def show
    @token = Token.find(params[:id])
    @new_token_request = TokenRequest.new
  end

  def update
    token = Token.find(params[:id])
    token.update_attributes!(params[:token])
  rescue ActiveRecord::StaleObjectError
    flash[:error] = "The token has already been updated by another user."
  ensure
    redirect_to token_path(token)
  end
end
