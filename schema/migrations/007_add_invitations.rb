class AddInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.string :code, :limit => 32
    end
    add_index :invitations, :code
  end
  
  def self.down
    drop_table :invitations
  end
end