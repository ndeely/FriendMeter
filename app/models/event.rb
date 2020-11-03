class Event < ApplicationRecord
    has_many :attending                          
    has_many :comments
    has_many :reviews
    has_many :invites
end
