class AlbumThumbnailMigration < ActiveRecord::Migration
  def self.up
    add_column :albums, :album_thumbnail_id, :integer
    add_index :albums, :album_thumbnail_id
    Album.find(:all).each do |album|
      album.update_attribute :album_thumbnail_id, (album.photos.first.id rescue nil)
    end
  end

  def self.down
    remove_column :albums, :album_thumbnail_id
  end
end
