class WikiWordMigration < ActiveRecord::Migration
  def self.up
    create_table :wiki_words do |t|
      t.integer :source_id, :destination_id
    end
    add_index :wiki_words, :source_id
    add_index :wiki_words, :destination_id
  end

  def self.down
    drop_table :wiki_words
  end
end
