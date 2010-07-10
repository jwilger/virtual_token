class TokensController < ApplicationController
  def new
    @token = Token.new
  end

  def create
    token = Token.create!(params[:token])
    redirect_to token_path(token)
  end

  def show
    @token = Token.find(params[:id])
  end
end
