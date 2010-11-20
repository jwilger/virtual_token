class TokenRequest < ActiveRecord::Base
  validates_presence_of :user_id
  validates_presence_of :token_id
  validates_presence_of :purpose
end
