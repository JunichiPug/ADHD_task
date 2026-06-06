class Routine < ApplicationRecord
  belongs_to :user
  has_many :tasks, -> { order(:position) }, dependent: :destroy

  accepts_nested_attributes_for :tasks, reject_if: :all_blank, allow_destroy: true

  def completed_tasks_count
    tasks.where(completed: true).count
  end

  # 時間ベースで割合を計算する
  def progress_rate
    total_duration = tasks.sum(:duration).to_f
    return 0 if total_duration.zero?

    # 完了したタスクの時間の合計
    completed_duration = tasks.where(completed: true).sum(:duration).to_f
    
    # パーセンテージを計算
    ((completed_duration / total_duration) * 100).round
  end
end