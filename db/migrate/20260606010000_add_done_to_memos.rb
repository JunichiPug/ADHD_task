class AddDoneToMemos < ActiveRecord::Migration[7.2]
  def change
    add_column :memos, :done, :boolean, default: false, null: false
  end
end
