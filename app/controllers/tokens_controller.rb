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
  rescue ActiveRecord::RecordNotFound
    @token = Token.create!(:slug => params[:id])
  end
end
