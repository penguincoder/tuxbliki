class AddAuthors < ActiveRecord::Migration
  def self.up
    create_table :authors do |t|
      t.string :name, :limit => 64
      t.string :url, :limit => 256
      t.timestamp :created_at
      t.string :salt, :limit => 512
      t.string :encrypted_password, :limit => 512
    end
    add_index :authors, :name
  end
  
  def self.down
    drop_table :authors
  end
end