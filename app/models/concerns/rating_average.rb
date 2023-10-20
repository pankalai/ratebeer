module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    if ratings.count > 0
      ratings.average(:score).round(2)
    else
      0
    end
  end
end
