class AddCheckinToStudent < ActiveRecord::Migration
  def self.up
    add_column :students, :active_checkin_id, :integer

    create_table(:checkins) do |t|
      t.references :destination
      t.references :student
      t.integer    :current_question_index
      t.boolean    :complete
    end
  end

  def self.down
    remove_column :students, :active_checkin_id
    drop_table :checkins
  end
end
