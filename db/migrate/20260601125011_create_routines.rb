class CreateRoutines < ActiveRecord::Migration[7.2]
  def change
    create_table :routines do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :color
      t.integer :current_position

      t.timestamps
    end
  end
end
