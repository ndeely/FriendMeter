json.extract! invite, :id, :event_id, :recipient_id, :created_at, :updated_at
json.url invite_url(invite, format: :json)
