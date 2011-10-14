class FixClaimGrantedAtValues < ActiveRecord::Migration
  TokenRequest = Class.new(ActiveRecord::Base)

  def self.up
    TokenRequest.where("position = ? AND claim_granted_at IS NULL", 1).all.each do |tr|
      tr.update_attributes!(:claim_granted_at => Time.now)
    end
  end

  def self.down
  end
end
