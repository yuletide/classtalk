class SplitName < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    User.all.each do |user|
      unless user.name.blank?
        user.first_name = user.name.split[0]
        user.last_name = user.name.split[1..-1].join(' ').presence
        user.save(false)
      end
    end
    remove_column :users, :name
  end

  def self.down
    add_column :users, :name, :string
    User.all.each do |user|
      unless user.first_name.blank? && user.last_name.blank?
        user.name = [user.first_name, user.last_name].compact.join(' ')
        user.save(false)
      end
    end
    remove_column :users, :last_name
    remove_column :users, :first_name
  end
end
