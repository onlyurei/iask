class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries, :force => true do |t|
      t.integer :course_id, :default => 0, :null => false
      t.integer :user_id, :default => 0, :null => false
      t.string :question, :default => "", :null => false
      t.text :answer, :null => false
      t.text :notes
      t.string :user_official_id, :default => "", :null => false
      t.string :user_last_name, :default => "", :null => false
      t.string :user_first_name, :default => "", :null => false

      t.timestamps
    end
  end

  def self.down
    drop_table :entries
  end
end
