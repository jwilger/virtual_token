class CreateTokens < ActiveRecord::Migration
  def self.up
    create_table :tokens do |t|
      t.string :name, :allow_nil => false
      t.string :slug, :allow_nil => false

      t.timestamps
    end
  end

  def self.down
    drop_table :tokens
  end
end
