class Task < ApplicationRecord
  belongs_to :routine

  # 0以上の数値であることを強制するバリデーション
  validates :duration, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :completed, -> { where(completed: true) }
end
