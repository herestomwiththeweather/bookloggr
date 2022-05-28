class RemoveMicropubPostUrlFromLogs < ActiveRecord::Migration[7.0]
  def change
    remove_column :logs, :micropub_post_url, :string
  end
end
