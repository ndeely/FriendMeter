class Event < ApplicationRecord
    has_many :attending                          
    has_many :comments
    has_many :reviews
    has_many :invites
    has_one_attached :avatar
end
