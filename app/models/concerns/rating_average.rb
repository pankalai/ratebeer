module RatingAverage
  extend ActiveSupport::Concern

  def average_rating
    # ratings.count == 0 ? 0 : ratings.average(:score).round(2)
    rating_count = ratings.size

    # rating_count == 0 ? 0 : ratings.map{ |r| r.score }.sum / rating_count
    return 0 if rating_count == 0

    ratings.map(&:score).sum / rating_count
  end
end
