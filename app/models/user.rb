class User < ApplicationRecord
  include RatingAverage
  has_secure_password

  PASSWORD_REQUIREMENTS = /\A
      (?=.*\d)           # Must contain a digit
      (?=.*[A-Z])        # Must contain an upper case character
  /x

  validates :password, length: { minimum: 4 }
  validates :password, format: { with: PASSWORD_REQUIREMENTS, message: "must have at least one capital letter and at least one number" }

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 30 }

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships
end
