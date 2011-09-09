class AddShowPopupToUser < ActiveRecord::Migration
  def self.up
    add_column :users, :show_group_number_popup, :boolean, :default => true
    User.find_each do |user|
      user.update_attribute(:show_group_number_popup, true)
    end
  end

  def self.down
    remove_column :users, :show_group_number_popup
  end
end
