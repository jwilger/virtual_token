class RemoveUrgent < ActiveRecord::Migration
  def self.up
    remove_column :token_requests, :urgent
  end

  def self.down
    add_column :token_requests, :urgent, :boolean, :default => false, :null => false
  end
end
