class TokenRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :token, :inverse_of => :requests
  acts_as_list :scope => :token
  TOP_OF_QUEUE = 2 # position 1 is the current request

  validates_presence_of :user
  validates_presence_of :token
  validates_presence_of :purpose

  delegate :name, :to => :user, :prefix => true

  after_create :update_token

  def update_token
    token.touch
  end

  def grant_claim
    unless claim_granted?
      update_attribute(:claim_granted_at, Time.now)
      TokenRequestNotification.claim_granted(self).deliver
    end
  end

  def revoke_claim
    update_attribute(:claim_granted_at, nil)
  end

  def claim_granted?
    claim_granted_at.present?
  end
  
  def move(where)
    case where
    when 'top'
      insert_at TOP_OF_QUEUE
    when 'bottom'
      move_to_bottom
    when 'up'
      move_higher unless higher_item.first?
    when 'down'
      move_lower
    when 'claim'
      token.current_request.revoke_claim
      move_to_top
      grant_claim
    end
  end
end
