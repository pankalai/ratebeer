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

    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    favorite(:style)
  end

  def favorite_brewery
    favorite(:brewery)
  end

  def favorite(groupped_by)
    return nil if ratings.empty?

    grouped_ratings = ratings.group_by{ |r| r.beer.send(groupped_by) }
    averages = grouped_ratings.map do |group, ratings|
      { group:, score: average_of(ratings) }
    end

    averages.max_by{ |r| r[:score] }[:group]
  end

  def average_of(ratings)
    ratings.sum(&:score).to_f / ratings.count
  end

  def self.top(amount)
    User.all.sort_by{ |u| u.ratings.count }.reverse.first(amount)
  end

  # def method_missing(method_name, *args, &block)
  #   if method_name =~ /^favorite_/
  #     category = method_name[9..-1].to_sym
  #     self.favorite category
  #   else
  #     return super
  #   end
  # end

  # def favorite_style
  #   return nil if ratings.empty?

  #   beers.group(:style).average(:score).sort_by(&:last).reverse.first.first
  # end

  # def favorite_brewery
  #   return nil if ratings.empty?
  #   beers.group(:brewery).average(:score).sort_by(&:last).reverse.first.first.name
  # end
end
