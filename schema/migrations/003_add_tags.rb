class AddTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.string :name, :limit => 64
    end
    add_index :tags, :name
    create_table :pages_tags, :id => false do |t|
      t.integer :page_id
      t.integer :tag_id
    end
    add_index :pages_tags, :page_id
    add_index :pages_tags, :tag_id
  end
  
  def self.down
    drop_table :tags
    drop_table :pages_tags
  end
end