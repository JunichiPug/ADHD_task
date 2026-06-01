class Routine < ApplicationRecord
  belongs_to :user
  has_many :tasks, dependent: :destroy

  # 💡 reject_if: :all_blank を追加して、中身が空のタスクは保存を無視するようにします
  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  def completed_tasks_count
    tasks.completed.count
  end

  def progress_rate
    return 0 if tasks.count == 0
    (completed_tasks_count.to_f / tasks.count * 100).round
  end
end