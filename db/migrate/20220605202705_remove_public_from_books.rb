class RemovePublicFromBooks < ActiveRecord::Migration[7.0]
  def change
    remove_column :books, :public, :boolean
  end
end
