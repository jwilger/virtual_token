class AddClaimedAtToTokens < ActiveRecord::Migration
  def self.up
    add_column :tokens, :claimed_at, :datetime
  end

  def self.down
    remove_column :tokens, :claimed_at
  end
end
