class RemoveClaimantColumnFromTokens < ActiveRecord::Migration
  def self.up
    user = User.create!(:name => 'System', :email => 'no-reply@example.com', :password => 'st&&w4lk', :password_confirmation => 'st&&w4lk')
    user.lock_access!

    create_table :_claimant_backups do |t|
      t.integer :token_id, :null => false
      t.string :claimant, :null => false
    end

    Token.where(:claimant => 'IS NOT NULL').each do |token|
      execute(%Q{INSERT INTO _claimant_backups (token_id, claimant) VALUES(?, ?)}, token.id, token.claimant)
      TokenRequest.create!(:token => token, :user => user, :purpose => token.claimant)
    end

    remove_column :tokens, :claimant
  end

  def self.down
    user = User.find_by_email('no-reply@example.com')
    user.destroy
    add_column :tokens, :claimant, :string

    backup = Class.new(ActiveRecord::Base) do
      set_table_name '_claimant_backups'
    end

    backup.all.each do |row|
      token = Token.find_by_id(row.token_id)
      unless token.nil?
        token.update_attribute(:claimant, row.claimant)
      end
    end

    drop_table :_claimant_backups
  end
end
