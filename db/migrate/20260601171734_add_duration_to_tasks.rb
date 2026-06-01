class AddDurationToTasks < ActiveRecord::Migration[7.2]
  def change
    add_column :tasks, :duration, :integer
  end
end
