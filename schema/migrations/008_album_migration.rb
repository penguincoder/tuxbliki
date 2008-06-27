class AlbumMigration < ActiveRecord::Migration
  def self.up
    create_table :albums do |t|
      t.string :name, :limit => 128
    end
    add_index :albums, :name
    create_table :albums_tags, :id => false do |t|
      t.integer :album_id
      t.integer :tag_id
    end
    add_index :albums_tags, :album_id
    add_index :albums_tags, :tag_id
  end

  def self.down
    drop_table :albums
    drop_table :albums_tags
  end
end
