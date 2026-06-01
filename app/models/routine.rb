class Routine < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  def completed_tasks_count
    tasks.completed.count
  end

  def progress_rate
    return 0 if tasks.count == 0
    (completed_tasks_count.to_f / tasks.count * 100).round
  end
end