class AddShowPopupToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :show_group_number_popup, :boolean, :default => true
  end

  def self.down
    remove_column :users, :show_group_number_popup
  end
end
