class CreateCoursesUsers < ActiveRecord::Migration
  def self.up
    create_table :courses_users, :force => true, :id => false do |t|
      t.integer :course_id, :null => false, :default => 0
      t.integer :user_id, :null => false, :default => 0
    end
    
    add_index :courses_users, [:course_id, :user_id]
    add_index :courses_users, :course_id
    add_index :courses_users, :user_id
  end

  def self.down
    drop_table :courses_users
  end
end
