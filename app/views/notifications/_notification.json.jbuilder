json.extract! notification, :id, :user_id, :title, :desc, :sender_id, :created_at, :updated_at
json.url notification_url(notification, format: :json)
