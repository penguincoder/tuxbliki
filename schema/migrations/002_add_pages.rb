class AddPages < ActiveRecord::Migration
  def self.up
    create_table :pages do |t|
      t.string :name, :limit => 64
      t.string :department, :limit => 128
      t.boolean :published, :default => false
      t.timestamp :created_at
      t.integer :author_id, :nid
      t.text :description
    end
    add_index :pages, :name
    add_index :pages, :published
    add_index :pages, :author_id
    add_index :pages, :nid
  end
  
  def self.down
    drop_table :pages
  end
end
