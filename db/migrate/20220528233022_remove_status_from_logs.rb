class RemoveStatusFromLogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :logs, :status, :string
  end
end
