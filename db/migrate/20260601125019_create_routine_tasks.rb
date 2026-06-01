class CreateRoutineTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :routine_tasks do |t|
      t.references :routine, null: false, foreign_key: true
      t.string :title
      t.integer :required_time
      t.integer :position

      t.timestamps
    end
  end
end
