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

  def favorite_beer
    return nil if ratings.empty?

    # ratings.sort_by{ |r| r.score }.last.beer
    # ratings.sort_by(&:score).last.beer
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?

    beers.group(:style).average(:score).sort_by(&:last).reverse.first.first
  end

  def favorite_brewery
    return nil if ratings.empty?

    beers.group(:brewery).average(:score).sort_by(&:last).reverse.first.first.name
    # best = beers.group(:brewery).average(:score).sort_by(&:last).reverse.first.second
    # beers.group(:brewery).average(:score).sort_by(&:last).select{|e,t| t == best}.map{|row| row[0]}
  end
end
