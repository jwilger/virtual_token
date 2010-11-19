class AddUrgentColumnToTokenRequests < ActiveRecord::Migration
  def self.up
    add_column :token_requests, :urgent, :boolean, :default => false, :null => false
  end

  def self.down
    remove_column :token_requests, :urgent
  end
end
