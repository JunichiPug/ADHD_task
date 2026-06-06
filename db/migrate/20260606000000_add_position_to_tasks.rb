class AddPositionToTasks < ActiveRecord::Migration[7.2]
  def up
    add_column :tasks, :position, :integer

    # 既存タスクに id 順で position を採番
    Routine.reset_column_information
    Routine.find_each do |routine|
      routine.tasks.order(:id).each_with_index do |task, i|
        task.update_column(:position, i)
      end
    end
  end

  def down
    remove_column :tasks, :position
  end
end
