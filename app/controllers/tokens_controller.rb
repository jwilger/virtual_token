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
  end

  def update
    token = Token.find(params[:id])
    token.update_attributes!(params[:token])
    redirect_to token_path(token)
  end
end
