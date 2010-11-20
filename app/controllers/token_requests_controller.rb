class TokenRequestsController < ApplicationController
  def create
    TokenRequest.create!
  rescue ActiveRecord::RecordInvalid => e
    @token = Token.find(params[:token_id])
    @new_token_request = e.record
    render 'tokens/show'
  end
end
