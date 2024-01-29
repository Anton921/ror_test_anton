class CreateTasks < ActiveRecord::Migration[7.1]
  def up
    create_table :tasks do |t|
      t.string :name, null: false
      t.text :description, null: false
      t.integer :status, default: 0

      t.timestamps
    end

    add_reference :tasks, :project, foreign_key: true
  end

  def down
    drop_table :tasks
  end
end
