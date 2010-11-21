class TokenRequestNotification < ActionMailer::Base
  default :from => "no-reply@virtual-token.heroku.com"

  def claim_granted(token_request)
    @token_request = token_request
    @token = token_request.token
    @user = token_request.user

    mail :to => @user.email, :subject => "It's your turn with the #{@token.name} token"
  end
end
