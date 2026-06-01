class Routine < ApplicationRecord
  belongs_to :user
  has_many :routine_tasks, dependent: :destroy
end