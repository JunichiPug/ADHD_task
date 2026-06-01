class AddEstimatedTimeToRoutines < ActiveRecord::Migration[7.2]
  def change
    add_column :routines, :estimated_time, :integer
  end
end
