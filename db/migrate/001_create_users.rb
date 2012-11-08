class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.column :official_id,               :string, :default => "", :null => false
      t.column :login,                     :string
      t.column :email,                     :string
      t.column :last_name,                 :string, :limit => 80
      t.column :first_name,                :string, :limit => 80
      t.column :is_admin,                  :boolean, :default => false, :null => false
      t.column :is_teacher,                :boolean, :default => false, :null => false
      t.column :entries_sum,               :integer, :default => 0, :null => false
      t.column :comment,                   :text
      t.column :crypted_password,          :string, :limit => 40
      t.column :salt,                      :string, :limit => 40
      t.column :created_at,                :datetime
      t.column :updated_at,                :datetime
      t.column :remember_token,            :string
      t.column :remember_token_expires_at, :datetime
    end
    User.delete_all
    admin = User.create(:login => "administrator", :password => "veronica", :password_confirmation => "veronica", :official_id => "000000",
                        :email => "admin@iask.com", :is_admin => true)
    admin.save!
  end

  def self.down
    drop_table "users"
  end
end
