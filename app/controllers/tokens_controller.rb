class TokensController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound do
    flash[:error] = "Token #{params[:id]} not found."
    redirect_to '/tokens'
  end

  def new
    @token = Token.new
  end

  def index
    @tokens = Token.all(:order => 'updated_at desc')
  end

  def destroy
    begin
      Token.transaction do
        @token = Token.find_by_slug!(params[:id])
        raise ActiveRecord::ActiveRecordError if @token.claimed?
        @token.destroy
        flash[:notice] = "Destroyed the #{params[:id]} token."
      end
    rescue ActiveRecord::ActiveRecordError
      flash[:error] = "Unable to destroy the #{params[:id]} token."
    end
    redirect_to '/tokens'
  end

  def create
    token = Token.create!(params[:token])
    redirect_to token_path(token)
  rescue ActiveRecord::RecordInvalid => e
    @token = e.record
    render :action => :new
  end

  def show
    @token = Token.find_by_slug!(params[:id])
    @other_tokens = Token.other_tokens(@token)
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
