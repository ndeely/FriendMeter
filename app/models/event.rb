class Event < ApplicationRecord
    has_many :comments
    has_many :reviews
end
