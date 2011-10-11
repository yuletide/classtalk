class AddRepliesAllToGroup < ActiveRecord::Migration
  def self.up
    add_column :groups, :replies_all, :boolean, :default=>false
  end

  def self.down
    remove_column :groups, :replies_all
  end
end
