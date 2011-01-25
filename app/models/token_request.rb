class TokenRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :token, :inverse_of => :requests
  acts_as_list :scope => :token

  validates_presence_of :user
  validates_presence_of :token
  validates_presence_of :purpose

  delegate :name, :to => :user, :prefix => true

  def claim_granted
    unless claim_granted?
      update_attribute(:claim_granted_at, Time.now)
      TokenRequestNotification.claim_granted(self).deliver
    end
  end

  def claim_granted?
    claim_granted_at.present?
  end
end
