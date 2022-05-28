json.extract! post, :id, :status, :micropub_post_url, :user_id, :book_id, :created_at, :updated_at
json.url post_url(post, format: :json)
