class User < ApplicationRecord
  #has_many :friends
  has_many :events
  has_many :notifications
  #has_many :comments
  #has_many :reviews
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
