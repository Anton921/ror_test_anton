class CreateProjects < ActiveRecord::Migration[7.1]
  def up
    create_table :projects do |t|
      t.string :name, null: false
      t.text :description, null: false

      t.timestamps
    end
  end

  def down
    drop_table :projects
  end
end
