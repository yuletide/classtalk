class AddGroupDestinationNumber < ActiveRecord::Migration
  def self.up
    add_column :groups, :destination_phone_number, :string
  end

  def self.down
    remove_column :groups, :destination_phone_number
  end
end
