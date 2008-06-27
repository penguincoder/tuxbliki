class AddComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.string :user, :limit => 32
      t.string :url, :limit => 256
      t.timestamp :created_at
      t.integer :author_id
      t.integer :page_id
      t.text :comment
    end
    add_index :comments, :author_id
    add_index :comments, :page_id
  end
  
  def self.down
    drop_table :comments
  end
end