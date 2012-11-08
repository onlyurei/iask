class CreateKeywords < ActiveRecord::Migration
  def self.up
    create_table :keywords, :force => true do |t|
      t.string :value, :default => "", :null => false, :limit => 100
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :keywords
  end
end
