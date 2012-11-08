class CreateNotes < ActiveRecord::Migration
  def self.up
    create_table :notes, :force => true do |t|
      t.integer :user_id, :default => 0, :null => false
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :notes
  end
end