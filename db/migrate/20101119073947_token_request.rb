class TokenRequest < ActiveRecord::Migration
  def self.up
    create_table :token_requests do |t|
      t.integer :user_id, :null => false
      t.integer :token_id, :null => false
      t.string :purpose
      t.timestamps
    end
  end

  def self.down
    drop_table :token_requests
  end
end
