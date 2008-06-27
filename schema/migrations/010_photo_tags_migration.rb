class PhotoTagsMigration < ActiveRecord::Migration
  def self.up
    create_table :photo_tags do |t|
      t.integer :x, :y, :photo_id, :tag_id
    end
    add_index :photo_tags, :photo_id
    add_index :photo_tags, :tag_id
  end

  def self.down
    drop_table :photo_tags
  end
end
