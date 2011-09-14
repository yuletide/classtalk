class AddQuestionAndAnswers < ActiveRecord::Migration
  def self.up
    remove_column :destinations, :questions

    create_table(:questions) do |t|
      t.references :destination
      t.string     :content
      t.integer    :order_index
      t.timestamps
    end

    create_table(:answers) do |t|
      t.references :question
      t.references :student
      t.string     :content
      t.timestamps
    end

  end

  def self.down
    add_column :destinations, :questions, :text
    drop_table :questions
    drop_table :answers
  end
end
