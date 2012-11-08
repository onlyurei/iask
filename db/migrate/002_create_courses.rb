class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses, :force => true do |t|
      t.string :official_id, :default => "", :null => false
      t.string :name, :default => "", :null => false
      t.text :description, :null => false
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :courses
  end
end
