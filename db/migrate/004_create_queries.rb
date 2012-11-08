class CreateQueries < ActiveRecord::Migration
  def self.up
    create_table :queries, :force => true do |t|
      t.integer :course_id, :default => 0, :null => false
      t.integer :student_id, :default => 0, :null => false
      t.integer :teacher_id, :default => 0, :null => false
      t.string :question, :default => "", :null => false
      t.text :answer
      t.boolean :solved, :default => false, :null => false
      t.text :notes
      t.string :course_official_id, :default => "", :null => false
      t.string :course_name, :default => "", :null => false
      t.string :student_official_id, :default => "", :null => false
      t.string :student_last_name, :default => "", :null => false
      t.string :student_first_name, :default => "", :null => false
      t.string :teacher_official_id, :default => "", :null => false
      t.string :teacher_last_name, :default => "", :null => false
      t.string :teacher_first_name, :default => "", :null => false

      t.timestamps
    end
    
    add_index :queries, [:course_id, :student_id]
    add_index :queries, [:course_id, :teacher_id]
    add_index :queries, :course_id
    add_index :queries, :student_id
    add_index :queries, :teacher_id
  end

  def self.down
    drop_table :queries
  end
end
