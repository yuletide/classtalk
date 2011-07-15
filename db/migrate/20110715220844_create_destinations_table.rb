class CreateDestinationsTable < ActiveRecord::Migration
  def self.up
    create_table(:destinations) do |t|
      t.string :name
      t.string :address
      t.text   :notes
      t.string :hashtag
      t.text   :questions
      t.integer   :group_id
    end
  end

  def self.down
    drop_table :destinations
  end
end
