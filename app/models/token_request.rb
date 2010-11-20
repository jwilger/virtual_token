class TokenRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :token

  validates_presence_of :user
  validates_presence_of :token
  validates_presence_of :purpose
end
