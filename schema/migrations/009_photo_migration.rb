class PhotoMigration < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :author_id, :width, :height, :album_id
      t.string :filename, :content_type
    end
    add_index :photos, :author_id
    add_index :photos, :album_id
  end

  def self.down
    drop_table :photos
  end
end
