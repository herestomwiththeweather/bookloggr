class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.boolean :public
      t.belongs_to :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
