class AddPermissions < ActiveRecord::Migration
  def self.up
    create_table :permissions do |t|
      t.string :name, :limit => 32
    end
    add_index :permissions, :name
    create_table :authors_permissions, :id => false do |t|
      t.integer :author_id
      t.integer :permission_id
    end
    add_index :authors_permissions, :author_id
    add_index :authors_permissions, :permission_id
  end
  
  def self.down
    drop_table :permissions
    drop_table :authors_permissions
  end
end