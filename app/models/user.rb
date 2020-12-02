class User < ApplicationRecord
  has_many :events
  has_many :notifications
  has_many :friends
  has_one_attached :avatar
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def address
    [street, city, state, country].compact.join(', ')
  end

  def address_changed?
    street_changed? || city_changed? || state_changed? || country_changed?
  end

  geocoded_by :address, latitude: :lat, longitude: :lng
  after_validation :geocode, if: ->(obj){ obj.address.present? and obj.address_changed? }

end
