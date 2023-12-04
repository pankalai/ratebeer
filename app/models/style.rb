class Style < ApplicationRecord
  include RatingAverage
  extend TopN

  has_many :beers
  has_many :ratings, through: :beers

  # def self.top(amount)
  #   Style.all.sort_by(&:average_rating).reverse.first(amount)
  # end
end
