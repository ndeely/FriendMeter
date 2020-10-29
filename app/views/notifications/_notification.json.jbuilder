json.extract! notification, :id, :title, :text, :recipient, :sender, :created_at, :updated_at
json.url notification_url(notification, format: :json)
