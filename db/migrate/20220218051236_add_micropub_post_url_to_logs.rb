class AddMicropubPostUrlToLogs < ActiveRecord::Migration[7.0]
  def change
    add_column :logs, :micropub_post_url, :string, default: ''
  end
end
