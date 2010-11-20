class TokenRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :token, :inverse_of => :requests

  validates_presence_of :user
  validates_presence_of :token
  validates_presence_of :purpose

  delegate :name, :to => :user, :prefix => true

  def claim_granted
    if claim_granted_at.nil?
      update_attribute(:claim_granted_at, Time.now)
    end
  end
end
