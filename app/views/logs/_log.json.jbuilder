json.extract! log, :id, :status, :note, :page, :user_id, :book_id, :created_at, :updated_at
json.url log_url(log, format: :json)
