class CreateRelevances < ActiveRecord::Migration
  def self.up
    create_table :relevances, :force => true do |t|
      t.integer :entry_id, :default => 0, :null => false
      t.integer :keyword_id, :default => 0, :null => false
      t.integer :value, :default => 0, :null => false

      t.timestamps
    end
    add_index :relevances, [:entry_id, :keyword_id]
    add_index :relevances, :entry_id
    add_index :relevances, :keyword_id
  end

  def self.down
    drop_table :relevances
  end
end
