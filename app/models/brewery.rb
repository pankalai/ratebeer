class Brewery < ApplicationRecord
  include RatingAverage
  extend TopN

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: { greater_than_or_equal_to: 1040,
                                   only_integer: true,
                                   less_than_or_equal_to: ->(_) { Time.now.year } }
  # validate :year_cannot_be_in_the_future

  scope :active, -> { where active: true }
  scope :retired, -> { where active: [nil, false] }

  def year_cannot_be_in_the_future
    return unless year > Date.today.year

    errors.add(:year, "can't be in the future")
  end

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
  end

  def restart
    self.year = 2022
    puts "changed year to #{year}"
  end

  # def self.top(amount)
  #   Brewery.all.sort_by(&:average_rating).reverse.first(amount)
  # end
end
