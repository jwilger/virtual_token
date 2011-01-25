class AddPositionToTokenRequest < ActiveRecord::Migration
  def self.up
    add_column :token_requests, :position, :integer
    execute 'UPDATE token_requests SET position = id'
  end

  def self.down
    remove_column :token_requests, :position
  end
end