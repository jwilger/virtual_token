class TokenRequestQueueObserver < ActiveRecord::Observer
  observe :token_request

  def after_create(request)
    request.token.update_queue
  end
  alias_method :after_destroy, :after_create
end
