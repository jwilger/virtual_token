class AddOptimisticLocking < ActiveRecord::Migration
  def self.up
    add_column :tokens, :lock_version, :integer
  end

  def self.down
    remove_column :tokens, :lock_version
  end
end
