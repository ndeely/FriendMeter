json.extract! review, :id, :text, :rating, :created_at, :updated_at
json.url review_url(review, format: :json)
