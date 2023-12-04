class Beer < ApplicationRecord
  include RatingAverage
  extend TopN

  belongs_to :style
  belongs_to :brewery, touch: true
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, length: { minimum: 1 }
  validates :style, length: { minimum: 1 }

  # def average_rating3
  #   (self.ratings.sum(:score)/self.ratings.count).to_f
  # end

  # def average_rating2
  #   self.ratings.average(:score)
  # end

  # include Enumerable
  # def average_rating
  #   scores = self.ratings.map{|x| x["score"]}
  #   (scores.reduce(:+)/scores.size.to_f).round(2)
  # end

  def to_s
    "#{name} (#{brewery.name})"
  end

  def average
    return 0.0 if ratings.empty?

    ratings.map(&:score).sum / ratings.count.to_f
  end

  # def self.top(amount)
  #   Beer.all.sort_by(&:average_rating).reverse.first(amount)
  # end
end
