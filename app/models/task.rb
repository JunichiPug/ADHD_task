class Task < ApplicationRecord
  belongs_to :routine

  scope :completed, -> { where(completed: true) }
end
