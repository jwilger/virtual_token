class AddClaimantToTokens < ActiveRecord::Migration
  def self.up
    add_column :tokens, :claimant, :string
  end

  def self.down
    remove_column :tokens, :claimant
  end
end
