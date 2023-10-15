class Beer < ApplicationRecord
  include RatingAverage

  belongs_to :brewery
  has_many :ratings, dependent: :destroy
 
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
    self.name + " (" + self.brewery.name + ")"
end

end
