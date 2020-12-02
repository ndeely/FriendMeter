class Event < ApplicationRecord
    has_many :attending                          
    has_many :comments
    has_many :reviews
    has_many :invites
    has_one_attached :avatar

    def address
        [street, city, state, country].compact.join(', ')
    end

    def address_changed?
        street_changed? || city_changed? || state_changed? || country_changed?
    end

    geocoded_by :address, latitude: :lat, longitude: :lng
    after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }
end
